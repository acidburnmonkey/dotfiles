local opts = { noremap = true, silent = true }
-- Require functions file
local functions = require('functions')


vim.keymap.set("n", "<leader><TAB>", ":bnext<CR>") -- Tab next
vim.keymap.set({"x",'v','n'}, "E", "ge") -- go back
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move block
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") --  move block
vim.keymap.set("n", "<leader>r", [[:%s#\<<C-r><C-w>\>#<C-r><C-w>#gI<Left><Left><Left>]]) -- global remap
vim.keymap.set('v', '<leader>r',functions.replace_word_under_cursor_in_selection, opts) -- visual remap
vim.keymap.set("n", "J", "mzJ`z") -- append line
vim.keymap.set("n", "<C-d>", "<C-d>zz") --move half page
vim.keymap.set("n", "<C-u>", "<C-u>zz") --move half page

-- Close all buffers (tabs) but the current one
vim.keymap.set('n', '<leader>b', functions.bufonly, opts)


-- ############################
-- Default behavior overrides #
-- ############################

vim.keymap.set("n", "x", [["_x]]) --void x
vim.keymap.set("x", "p", [["_dP]]) -- void paste
vim.keymap.set('n', 'Q', 'q', opts) -- Remap 'Q' to start recording macros
vim.keymap.set('x', 'W', 'iW', opts) -- remaps viW to just vW
vim.keymap.set('v', 'w', 'iw', opts) -- remaps viw to just vw
vim.keymap.set('n', 'P', 'o<Esc>p', opts) --void P
vim.keymap.set('n', 'd', '"_d', opts) --void d
vim.keymap.set('v', 'd', '"_d', opts)
vim.keymap.set('n', '<leader>d', 'daw', opts)
vim.keymap.set('n', 'cw', 'ciw', { noremap = true, nowait = true, silent = true }) -- cw = ciw


--use Tab to navigate menu snippets menu
vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>'
    else
        return '<Tab>'
    end
end, { expr = true, noremap = true })

-- Disable
vim.keymap.set({'x','v','n'}, '<F1>', '<Nop>', opts)
vim.keymap.set('n', 's', '<Nop>', opts)
vim.keymap.set('n', 'S', '<Nop>', opts)
vim.keymap.set('n', 'q', '<Nop>', opts)

-- ############################
-- Plugins keymaps           #
-- ############################

vim.cmd([[nnoremap \ :Neotree toggle<cr>]])
vim.keymap.set('n', '<F12>', functions.toggle_floaterm, opts)

-- To avoid neotree from crashing all vim, closes the tab
vim.keymap.set("n", "<leader>q", functions.bufremove, { desc = "Delete buffer" })

--telescope
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>")
vim.keymap.set('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>")
vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")

-- Splelling suggestions on s
vim.keymap.set('n','s',function()
  local win  = 0
  local pos  = vim.api.nvim_win_get_cursor(win)
  local w    = vim.fn.expand('<cword>')
  local info = vim.fn.spellbadword()
  vim.api.nvim_win_set_cursor(win, pos)

  if info[1] == w and info[2] ~= '' then
    require('telescope.builtin').spell_suggest(
      require('telescope.themes').get_cursor{ winblend = 5 }
    )
  end
end,{desc='Telescope spell suggestions (only on typo under cursor)'})


vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>-', ':IBLToggle<CR>', opts)



-- show diagnostics
vim.keymap.set('n', '<F3>', function()
  require('telescope.builtin').diagnostics(
    require('telescope.themes').get_ivy{
      -- only show errors & warnings, not hints/info:
      severity_limit = vim.diagnostic.severity.WARN,
      layout_config = { height = 0.3 },
    }
  )
end, { desc = 'Telescope: show all diagnostics' })


-- ########
-- Macros #
-- ########

local esc = vim.api.nvim_replace_termcodes("<Esc>",true,true,true)
local cr  = vim.api.nvim_replace_termcodes("<C-R>\"", true, true, true)
--
-- Python: set up a single-keystroke macro in register ‘l’
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.fn.setreg("l", "y" .. "oprint('" .. cr .. ":' , " .. cr .. ")" .. esc)
    end,
})

-- JavaScript/TypeScript: same idea with console.log
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript" },
    callback = function()
        vim.fn.setreg("l", "y" .. "oconsole.log('" .. cr .. ":' , " .. cr .. ");" .. esc)
    end,
})

