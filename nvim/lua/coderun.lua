-- Coderun configuration: shortcuts for running code

-- Helper to easily set autocmds in Lua
local function buf_map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { noremap = true, silent = true, buffer = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Create all autocmds
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    buf_map('n', '<F10>', ':w<CR>:!python3 %<CR>')
    buf_map('i', '<F10>', '<Esc>:w<CR>:!python3 %<CR>')
    buf_map('n', '<F11>', ':w<CR>:FloatermNew --disposable --autoclose=0 python3 %<CR>')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'javascript',
  callback = function()
    buf_map('n', '<F10>', ':w<CR>:!node %<CR>')
    buf_map('i', '<F10>', '<Esc>:w<CR>:!node %<CR>')
    buf_map('n', '<F11>', ':w<CR>:FloatermNew --disposable --autoclose=0 node %<CR>')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    buf_map('n', '<F10>', ':w<CR>:!/bin/bash %<CR>')
    buf_map('i', '<F10>', '<Esc>:w<CR>:!/bin/bash %<CR>')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  callback = function()
    buf_map('n', '<F10>', ':!g++ -o %:p:r %<CR>:!%:p:r<CR>')
    buf_map('n', '<F9>', ':w<bar>:FloatermNew --autoclose=0 g++ -g -Wall % && ./a.out<CR>')
    buf_map('n', '<F11>', ':w<bar>:FloatermNew --disposable --autoclose=0 g++ -o %:p:r %<bar>/%:p:r<CR>')
  end,
})


vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    buf_map('n', '<F10>', ':w<CR>:!lua %<CR>')
    buf_map('n', '<F11>', ':w<bar>:FloatermNew --disposable --autoclose=0 lua %<CR>')
  end,
})


vim.api.nvim_create_autocmd('FileType', {
    pattern = 'typescript',
    callback = function()
        buf_map('n', '<F10>', ':w<CR>:!npx tsx %<CR>')
        buf_map('n', '<F11>', ':w<CR>:FloatermNew --disposable --autoclose=0 npx tsx %<CR>')
    end,
})
