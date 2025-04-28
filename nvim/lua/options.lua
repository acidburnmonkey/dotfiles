vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard:append('unnamedplus')
vim.cmd('filetype plugin on')
vim.opt.swapfile = false
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.scrolloff = 7
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.g.mapleader = ' '
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true

-- Spell generall options
vim.opt.spelllang = 'en_us'
vim.opt.spell = false
vim.opt.hlsearch = false
