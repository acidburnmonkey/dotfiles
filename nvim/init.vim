set number
set clipboard=unnamedplus
filetype plugin on

set scrolloff=7
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
let mapleader = ' '

"############
"#   Pugins #
"############

call plug#begin()

" python run f8
"Plug 'MunifTanjim/nui.nvim'
"Plug 'smzm/hydrovim'
Plug 'zchee/deoplete-jedi'
Plug 'jiangmiao/auto-pairs'
Plug 'brooth/far.vim'

Plug 'tpope/vim-commentary'


call plug#end()

"#####################
"#     Configs       # 
"#####################

autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

