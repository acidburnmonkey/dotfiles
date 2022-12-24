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
let mapleader = ' '
set encoding=utf8

"############
"#   Pugins #
"############

call plug#begin()

Plug 'L3MON4D3/LuaSnip'
""""""""""""""""""""""""""""""
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
""""""""""""""""""
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-jedi'
"''''''''''''''''''''''''''''''''''''
Plug 'gennaro-tedesco/nvim-peekup'
"''''''''''''''''''''
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
"''''''''''''''''''''''''''''''''''''''''''''
Plug 'preservim/nerdtree'
"''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'tpope/vim-surround'
"''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'ryanoasis/vim-devicons'
call plug#end()

"#####################
"#     Configs       # 
"#####################
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 

:nmap <F1> <nop>
"'''' registers ''''
let g:peekup_open = '<F5>'
let g:peekup_paste_after = '<leader>p'

"'''Python'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
vim.cmd.colorscheme "catppuccin"
EOF
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
nnoremap <F2> :NERDTreeToggle<CR>
:xmap S


set guifont=Hack\ Nerd\ Font\ 12
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
