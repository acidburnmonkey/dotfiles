set relativenumber
set clipboard+=unnamedplus
filetype plugin on
set noswapfile
set scrolloff=7
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
let mapleader=' '
set encoding=utf-8
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

"############
"#   Pugins #
"############

call plug#begin()

"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'lukas-reineke/indent-blankline.nvim'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'norcalli/nvim-colorizer.lua'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'mbbill/undotree'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"''''''''''''''''''''''''''''''''''''''''''''''"''''''''''''''''''
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
""""""""""""""""""""""""""'''''''''''''''''''''''''''''''''''""""
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary' 
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-jedi'
"''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'gennaro-tedesco/nvim-peekup'
"''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
"''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'tpope/vim-surround'
"'''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'ryanoasis/vim-devicons'
"''''''''''''''''''''''''''''''''''''''''''''''''''
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'VonHeikemen/lsp-zero.nvim'

call plug#end()


"#####################
"     Remaps         #
"#####################

"From plugins
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap \ :Neotree reveal<cr>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>- :IndentBlanklineToggle<CR>

lua vim.keymap.set("n", "<leader>r", [[:%s#\<<C-r><C-w>\>#<C-r><C-w>#gI<Left><Left><Left>]])
:nmap P o<ESC>p
nnoremap d "_d
vnoremap d "_d
nnoremap ("<C-d>", "<C-d>zz")
nnoremap ("<C-u>", "<C-u>zz")
:map s <nop>
lua vim.keymap.set("v", "K",":m '<-2<CR>gv=gv")
lua vim.keymap.set("v", "J",":m '>+1<CR>gv=gv")
lua vim.keymap.set("x", "p", "\"_dP")
lua vim.keymap.set("n", "<leader>y", "\"+y")
lua vim.keymap.set("v", "<leader>y", "\"+y")

"#####################
"#     Configs       # 
"#####################

imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
autocmd VimEnter * WipeReg
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
:map <C-w> daw 
:map <F1> <nop>
"'''' registers ''''
let g:peekup_open = '<F5>'
let g:peekup_paste_after = '<leader>p'

"''''''''''''Debugging'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
"Bash runing on maping
autocmd FileType sh map <buffer> <F10> :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
autocmd FileType sh imap <buffer> <F10> <esc>:w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
"C++
map  <F8> : !gcc % && ./a.out <CR>
"''''''''''''''' Theme '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
 vim.cmd.colorscheme "catppuccin-mocha"
EOF

"''''''''''''''''''''Font Icons ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
set guifont=Hack\ Nerd\ Font\ 12
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"'''''''''''''LSP'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
require("mason-lspconfig").setup {
    ensure_installed = {"rust_analyzer","jedi_language_server", "clangd"},
}
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
--shortcuts
local on_attach = function(_,_) 
   --Shift K for documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end     

require("lspconfig").jedi_language_server.setup {
    on_attach = on_attach 
    } 

require("lspconfig").clangd.setup {
    on_attach = on_attach 
    } 
EOF
"'''''''''''''''''''Bash lsp , installed trough dnf not plug '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})
EOF
"''''''''''''''''''''Zero Lsp''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
    local lsp = require('lsp-zero')
    lsp.preset('recommended')
    lsp.setup()
EOF
"'''''''''''''''''''Tree sitter highlight'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust","bash","python" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF
"''''''''''''''''''nvim-colorizer''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua require'colorizer'.setup()

