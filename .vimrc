set nu rnu
set clipboard+=unnamedplus
filetype plugin on
set noswapfile
set completeopt=menu,menuone,noselect
set scrolloff=7
set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
let mapleader=' '
set encoding=utf-8
set termguicolors 
"#####################
"     Remaps         #
"#####################


:nmap P o<ESC>p
nnoremap d "_d
vnoremap d "_d
:map <F1> <nop>
map <F1> <Esc>
imap <F1> <Esc>
map q <Nop>
map s <Nop>
map S <Nop>
nnoremap <CapsLock> <Esc>
inoremap <CapsLock> <Esc>
vnoremap <CapsLock> <Esc>

:map <leader>d daw 
:map <nowait> vw viw
:map <nowait> cw ciw
" autocmd VimEnter * WipeReg


" Void x
nnoremap x "_x
" Move block down in visual mode
vnoremap J :m '>+1<CR>gv=gv
" Move block up in visual mode
vnoremap K :m '<-2<CR>gv=gv
" Void paste in visual mode
xnoremap <leader>p "_dP
" Append line in normal mode
nnoremap J mzJ`z
" Move half page down and center cursor
nnoremap <C-d> <C-d>zz
" Move half page up and center cursor
nnoremap <C-u> <C-u>zz
