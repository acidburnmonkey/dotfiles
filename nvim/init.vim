set number
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
let mapleader= ' '
set encoding=utf8

"############
"#   Pugins #
"############

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
"''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
""""""""""""""""""""""""""''''''''''''''''''''''""""
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
"''''''''''''''''''''''''''''''''''''''''''''''''''
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
Plug 'preservim/nerdtree'
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
nnoremap("v", "J", ":m '>+1<CR>gv=gv")
nnoremap("v", "K", ":m '<-2<CR>gv=gv")

"#####################
"#     Configs       # 
"#####################
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
:map <C-w> daw 
:map <F1> <nop>
"'''' registers ''''
let g:peekup_open = '<F5>'
let g:peekup_paste_after = '<leader>p'

"''''''''''''Python'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

"''''''''''''''' Theme '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
vim.cmd.colorscheme "catppuccin"
EOF
"''''''''''''' Nerd tree '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
nnoremap <F2> :NERDTreeToggle<CR>
:xmap S

"''''''''''''''''''''Font Icons ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
set guifont=Hack\ Nerd\ Font\ 12
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"'''''''''''''LSP'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
require("mason-lspconfig").setup {
    ensure_installed = {"rust_analyzer","jedi_language_server"},
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
"'''''''''''''''''''Tree sitter highlight'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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

