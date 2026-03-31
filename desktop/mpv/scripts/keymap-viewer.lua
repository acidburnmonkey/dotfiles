-- keymap-viewer.lua
-- Telescope-style keybinding viewer for mpv
-- Default trigger: F12  (override with: script-opts=keymap-viewer-key=<key>)

local mp    = require 'mp'
local opts  = require 'mp.options'

local cfg = {
    key          = '?',
    max_visible  = 20,
    font         = 'monospace',
    font_size    = 13,
}
opts.read_options(cfg, 'keymap-viewer')

-- ── state ────────────────────────────────────────────────────────────────────

local ov = mp.create_osd_overlay('ass-events')

local st = {
    active  = false,
    query   = '',
    sel     = 1,
    offset  = 0,
    all     = {},
    list    = {},   -- filtered
}

-- ── helpers ───────────────────────────────────────────────────────────────────

local function esc_ass(s)
    return tostring(s):gsub('\\', '\\\\'):gsub('{', '\\{'):gsub('}', '\\}')
end

local function pad(s, n)
    s = tostring(s)
    if #s >= n then return s:sub(1, n-1) .. '…' end
    return s .. string.rep(' ', n - #s)
end

-- Make the command column human-readable
local function format_cmd(cmd)
    -- strip leading flags like "nonscalable", "no-osd", "osd-auto"
    cmd = cmd:gsub('^%s*nonscalable%s+', '')
    cmd = cmd:gsub('^%s*no%-osd%s+', '')
    cmd = cmd:gsub('^%s*osd%-[a-z]+%s+', '')

    -- script-binding owner/action  →  just the action, humanised
    local action = cmd:match('^script%-binding%s+[^/%s]+/(.+)$')
    if action then
        -- skip auto-generated names like __keybinding3
        if action:match('^__') then return cmd end
        -- underscores/hyphens → spaces, split camelCase, lowercase
        action = action:gsub('[_%-]', ' ')
        action = action:gsub('(%l)(%u)', '%1 %2')
        return action:lower()
    end

    -- script-message-to script toggle-foo  →  toggle foo
    local msg = cmd:match('^script%-message%-to%s+%S+%s+(.+)$')
    if msg then
        return msg:gsub('[_%-]', ' '):lower()
    end

    -- script-message toggle-foo
    local smsg = cmd:match('^script%-message%s+(.+)$')
    if smsg then
        return smsg:gsub('[_%-]', ' '):lower()
    end

    return cmd
end

-- ── data ──────────────────────────────────────────────────────────────────────

-- Read input.conf to know which keys the user has explicitly bound
local function user_defined_keys()
    local keys = {}
    local path = mp.find_config_file('input.conf')
    if not path then return keys end
    local f = io.open(path, 'r')
    if not f then return keys end
    for line in f:lines() do
        -- skip blank lines and comment-only lines
        local key = line:match('^%s*([^%s#][^%s]*)')
        if key then keys[key] = true end
    end
    f:close()
    return keys
end

-- Priority: 0 = script, 1 = user input.conf, 2 = mpv default
local function binding_priority(b, user_keys)
    if b.owner and b.owner ~= '' and b.owner ~= 'default' then
        return 0   -- registered by a script
    end
    if user_keys[b.key] then
        return 1   -- explicitly set in input.conf
    end
    return 2       -- built-in default
end

local function collect()
    local raw      = mp.get_property_native('input-bindings') or {}
    local user_keys = user_defined_keys()
    local out = {}
    for _, b in ipairs(raw) do
        local cmd = b.cmd or ''
        if cmd ~= '' and cmd ~= 'ignore' and not cmd:match('^%s*#') then
            local owner = b.owner or ''
            out[#out+1] = {
                key      = b.key or '',
                cmd      = cmd,
                owner    = owner ~= '' and owner or 'default',
                section  = b.section or '',
                priority = binding_priority(
                    {owner = owner, key = b.key or ''},
                    user_keys
                ),
            }
        end
    end
    table.sort(out, function(a, b)
        if a.priority ~= b.priority then return a.priority < b.priority end
        return a.key < b.key
    end)
    return out
end

local function apply_filter(q)
    if q == '' then return st.all end
    local lq = q:lower()
    local res = {}
    for _, b in ipairs(st.all) do
        if b.key:lower():find(lq, 1, true)
            or b.cmd:lower():find(lq, 1, true)
            or b.owner:lower():find(lq, 1, true)
        then
            res[#res+1] = b
        end
    end
    return res
end

-- ── rendering ─────────────────────────────────────────────────────────────────

local COL_KEY   = 20
local COL_CMD   = 52
local COL_OWN   = 18

local function clamp_scroll()
    local n   = cfg.max_visible
    local idx = st.sel
    if idx < st.offset + 1       then st.offset = idx - 1 end
    if idx > st.offset + n       then st.offset = idx - n end
    local max_off = math.max(0, #st.list - n)
    st.offset = math.min(math.max(st.offset, 0), max_off)
end

-- Draw a filled rectangle using ASS vector drawing
local function make_rect(x1, y1, x2, y2, color_hex, alpha_hex)
    -- alpha_hex: '00'=opaque … 'FF'=invisible
    return string.format(
        '{\\an7\\pos(0,0)\\p1\\c&H%s&\\1a&H%s&\\3a&HFF&\\4a&HFF&\\bord0\\shad0}' ..
        'm %d %d l %d %d l %d %d l %d %d{\\p0}',
        color_hex, alpha_hex,
        x1, y1,  x2, y1,  x2, y2,  x1, y2
    )
end

local function render()
    -- Fix coordinate space so positions are predictable regardless of video res
    ov.res_x = 1280
    ov.res_y = 720

    local lines = {}
    local x, y  = 32, 20
    local f      = cfg.font
    local fs     = cfg.font_size
    local row_h  = fs + 4

    -- Pre-calculate total panel height
    local n_shown   = math.min(cfg.max_visible, math.max(1, #st.list))
    local panel_h   = 28 + 24 + 22 + 14 + (n_shown * row_h) + 24 + 16
    local panel_x1  = 16
    local panel_y1  = 10
    local panel_x2  = 960
    local panel_y2  = panel_y1 + panel_h

    -- ── background ──
    -- Outer dark panel
    lines[#lines+1] = make_rect(panel_x1, panel_y1, panel_x2, panel_y2, '0D0D0D', '00')
    -- Top accent bar
    lines[#lines+1] = make_rect(panel_x1, panel_y1, panel_x2, panel_y1 + 3, '00CCCC', '00')
    -- Thin border around panel
    lines[#lines+1] = make_rect(panel_x1,     panel_y1,     panel_x2,     panel_y1 + 1, '333333', '00')
    lines[#lines+1] = make_rect(panel_x1,     panel_y2 - 1, panel_x2,     panel_y2,     '333333', '00')
    lines[#lines+1] = make_rect(panel_x1,     panel_y1,     panel_x1 + 1, panel_y2,     '333333', '00')
    lines[#lines+1] = make_rect(panel_x2 - 1, panel_y1,     panel_x2,     panel_y2,     '333333', '00')

    -- ── header ──
    lines[#lines+1] = string.format(
        '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0\\c&H00CCCC&\\b1}⌨  MPV Keymaps' ..
        '{\\b0\\c&H666666&}  %d / %d',
        x, y, f, fs + 4, #st.list, #st.all
    )

    -- ── search bar ──
    y = y + 26
    -- Search bg highlight
    lines[#lines+1] = make_rect(panel_x1 + 1, y - 4, panel_x2 - 1, y + fs + 4, '1A1A1A', '00')
    local cursor = '{\\c&H00CCCC&}▌{\\c&HFFFFFF&}'
    local qdisp  = st.query ~= '' and esc_ass(st.query)
                   or '{\\c&H444444&}type to search…{\\c&HFFFFFF&}'
    lines[#lines+1] = string.format(
        '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0\\c&HFFFFFF&}/ %s%s',
        x, y, f, fs, qdisp, cursor
    )

    -- ── column headers ──
    y = y + 24
    lines[#lines+1] = string.format(
        '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0\\c&H555555&\\b1}%-' ..
        COL_KEY .. 's  %-' .. COL_CMD .. 's  %s{\\b0}',
        x, y, f, fs - 2,
        'KEY', 'COMMAND', 'OWNER'
    )
    -- Separator line under headers
    y = y + 12
    lines[#lines+1] = make_rect(panel_x1 + 1, y, panel_x2 - 1, y + 1, '2A2A2A', '00')

    -- ── entries ──
    y = y + 8
    clamp_scroll()

    if #st.list == 0 then
        lines[#lines+1] = string.format(
            '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0\\c&H555555&}  (no matches)',
            x, y, f, fs
        )
        y = y + row_h
    else
        local vis_end = math.min(st.offset + cfg.max_visible, #st.list)
        for i = st.offset + 1, vis_end do
            local b   = st.list[i]
            local sel = (i == st.sel)

            local key_s = esc_ass(pad(b.key, COL_KEY))
            local cmd_s = esc_ass(pad(format_cmd(b.cmd), COL_CMD))
            local own_s = esc_ass(b.owner)

            if sel then
                -- Selection highlight row
                lines[#lines+1] = make_rect(panel_x1 + 1, y - 2, panel_x2 - 1, y + fs + 2, '1E3A3A', '00')
                lines[#lines+1] = make_rect(panel_x1 + 1, y - 2, panel_x1 + 3, y + fs + 2, '00CCCC', '00')
                lines[#lines+1] = string.format(
                    '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0}' ..
                    '{\\c&H00CCCC&\\b1}%s{\\b0}  {\\c&HFFFFFF&}%s  {\\c&H44BB77&}%s',
                    x + 4, y, f, fs, key_s, cmd_s, own_s
                )
            else
                lines[#lines+1] = string.format(
                    '{\\an7\\pos(%d,%d)\\fn%s\\fs%d\\bord0\\shad0}' ..
                    '{\\c&HAAAA00&}%s{\\c&H999999&}  %s  {\\c&H444444&}%s',
                    x + 4, y, f, fs, key_s, cmd_s, own_s
                )
            end
            y = y + row_h
        end
    end

    -- ── scrollbar ──
    if #st.list > cfg.max_visible then
        local entries_y0 = panel_y1 + 28 + 24 + 22 + 14 + 8
        local track_h    = cfg.max_visible * row_h
        local frac       = st.offset / math.max(1, #st.list - cfg.max_visible)
        local thumb_h    = math.max(8, math.floor(track_h * cfg.max_visible / #st.list))
        local thumb_y    = entries_y0 + math.floor(frac * (track_h - thumb_h))
        -- Track
        lines[#lines+1] = make_rect(panel_x2 - 8, entries_y0, panel_x2 - 3, entries_y0 + track_h, '222222', '00')
        -- Thumb
        lines[#lines+1] = make_rect(panel_x2 - 8, thumb_y, panel_x2 - 3, thumb_y + thumb_h, '00CCCC', '00')
    end

    -- ── footer ──
    y = y + 6
    lines[#lines+1] = make_rect(panel_x1 + 1, y - 4, panel_x2 - 1, panel_y2 - 1, '111111', '00')
    lines[#lines+1] = string.format(
        '{\\an7\\pos(%d,%d)\\fn%s\\fs9\\bord0\\shad0\\c&H505050&}' ..
        '↑↓ / PgUp PgDn   navigate     Enter   execute     BS   delete char     Esc / q   close',
        x, y, f
    )

    ov.data = table.concat(lines, '\n')
    ov:update()
end

-- ── actions ───────────────────────────────────────────────────────────────────

-- Track which binding names we registered so we can clean up
local bound_names = {}

local function bind(key, name, fn)
    bound_names[#bound_names+1] = name
    mp.add_forced_key_binding(key, name, fn)
end

local function search_update(extra_char, delete)
    if delete then
        if #st.query > 0 then
            st.query = st.query:sub(1, -2)
        end
    elseif extra_char then
        st.query = st.query .. extra_char
    end
    st.sel    = 1
    st.offset = 0
    st.list   = apply_filter(st.query)
    render()
end

local function close_viewer()
    if not st.active then return end
    st.active = false
    ov:remove()
    for _, name in ipairs(bound_names) do
        mp.remove_key_binding(name)
    end
    bound_names = {}
end

local function execute()
    if #st.list == 0 then return end
    local cmd = st.list[st.sel].cmd
    close_viewer()
    mp.add_timeout(0.04, function() mp.command(cmd) end)
end

local function open_viewer()
    if st.active then close_viewer(); return end
    st.active  = true
    st.query   = ''
    st.sel     = 1
    st.offset  = 0
    st.all     = collect()
    st.list    = st.all
    bound_names = {}

    -- Navigation
    bind('UP',     'kv-up',    function()
        if st.sel > 1 then st.sel = st.sel - 1; render() end
    end)
    bind('DOWN',   'kv-down',  function()
        if st.sel < #st.list then st.sel = st.sel + 1; render() end
    end)
    bind('PGUP',   'kv-pgup',  function()
        st.sel = math.max(1, st.sel - cfg.max_visible); render()
    end)
    bind('PGDWN',  'kv-pgdn',  function()
        st.sel = math.min(#st.list, st.sel + cfg.max_visible); render()
    end)
    bind('ENTER',  'kv-enter', execute)
    bind('ESC',    'kv-esc',   close_viewer)
    bind('q',      'kv-q',     close_viewer)
    bind('BS',     'kv-bs',    function() search_update(nil, true) end)
    bind('Ctrl+h', 'kv-ch',    function() search_update(nil, true) end)

    -- Printable characters → search
    local chars_lower = 'abcdefghijklmnopqrstuvwxyz'
    local chars_upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local chars_digit = '0123456789'

    for i = 1, #chars_lower do
        local c = chars_lower:sub(i, i)
        bind(c, 'kv-l'..c, function() search_update(c) end)
    end
    for i = 1, #chars_upper do
        local C = chars_upper:sub(i, i)
        bind(C, 'kv-u'..C, function() search_update(C) end)
    end
    for i = 1, #chars_digit do
        local d = chars_digit:sub(i, i)
        bind(d, 'kv-d'..d, function() search_update(d) end)
    end

    local syms = {
        {'SPACE',      ' '},
        {'KP_DEC',     '.'},
        {'-',          '-'},
        {'_',          '_'},
        {'.',          '.'},
        {'/',          '/'},
        {':',          ':'},
        {';',          ';'},
        {'Shift+SPACE',' '},
    }
    for _, pair in ipairs(syms) do
        local key, char = pair[1], pair[2]
        bind(key, 'kv-sym'..string.byte(char)..key, function() search_update(char) end)
    end

    render()
end

mp.add_key_binding(cfg.key, 'keymap-viewer', open_viewer)
mp.msg.info('keymap-viewer loaded — press ' .. cfg.key .. ' to open')
