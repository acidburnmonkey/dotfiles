local M = {}

function M.toggle_floaterm()
  local bufnr = vim.fn
  if bufnr ~= -1 then
    vim.cmd('FloatermHide')
else
    vim.notify("No Floaterm open.", vim.log.levels.INFO)
  end
end

function M.replace_word_under_cursor_in_selection()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! gv')
  local word = vim.fn.expand('<cword>')
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  vim.api.nvim_win_set_cursor(0, current_pos)
  if replacement ~= '' then
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    vim.cmd(start_line .. ',' .. end_line .. 's/' .. word .. '/' .. replacement .. '/g')
  end
end


function M.bufonly()
  vim.cmd('silent! execute "%bd|e#|bd#"')
end

function M.remove_trailing_whitespace()
  local saved_search = vim.fn.getreg('/')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setreg('/', saved_search)
end


-- To avoid neotree from crashing all vim, closes the tab
function M.bufremove(buf)
    buf = buf or 0
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    if vim.bo.modified then
        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
        if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
            return
        end
        if choice == 1 then -- Yes
            vim.cmd.write()
        end
    end
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
                return
            end
            -- Try using alternate buffer
            local alt = vim.fn.bufnr("#")
            if alt ~= buf and vim.fn.buflisted(alt) == 1 then
                vim.api.nvim_win_set_buf(win, alt)
                return
            end
            -- Try using previous buffer
            local has_previous = pcall(vim.cmd, "bprevious")
            if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
                return
            end
            -- Create new listed buffer
            local new_buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_win_set_buf(win, new_buf)
        end)
    end
    if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete! " .. buf)
    end
end


return M

