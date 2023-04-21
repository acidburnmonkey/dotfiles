set nu rnu
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

Plug 'voldikss/vim-floaterm'
"''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
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
" ''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" ''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'tpope/vim-fugitive'
call plug#end()

"#####################
"     Remaps         #
"#####################

nnoremap \ :Neotree reveal<cr>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>- :IndentBlanklineToggle<CR>
let g:peekup_open = '<F5>'
"let g:peekup_paste_after = '<leader>0'

:nmap P o<ESC>p
nnoremap d "_d
vnoremap d "_d
:map <F1> <nop>
map <F1> <Esc>
imap <F1> <Esc>
map q <Nop>
map s <Nop>
map S <Nop>

:map <leader>d daw 
:map <nowait> vw viw
:map <nowait> cw ciw
autocmd VimEnter * WipeReg

"closes all buffers but current 
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <leader>b :BufOnly<CR>

"tabs 
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

lua <<EOF

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<leader>c", [[:s/\(\w.*\)/]])
vim.keymap.set("n", "<leader>r", [[:%s#\<<C-r><C-w>\>#<C-r><C-w>#gI<Left><Left><Left>]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--telescope
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>")
vim.keymap.set('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>")
vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")

vim.opt.hlsearch = false

EOF

"#####################
"#     Configs       # 
"#####################

"'''''''''''Force transparency if no compositor installed'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
    function force_backgraund(color)
        color = color or "catppuccin-mocha"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal",{bg = "none"} )
        vim.api.nvim_set_hl(0, "NormalFloat",{bg = "none"} )
    end

EOF
lua force_backgraund()
"'''''''''''''''''''''''''''''''''LuaSnip'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
lua require("luasnip.loaders.from_vscode").lazy_load()
"''''''''''''Coding'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

autocmd FileType sh map <buffer> <F10> :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
autocmd FileType sh imap <buffer> <F10> <esc>:w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>

augroup CBuild
  autocmd!
  autocmd filetype cpp nnoremap <buffer> <F10> :!g++ -o %:p:r %<cr>
  autocmd filetype cpp nnoremap <buffer> <leader>cr :!g++ -o %:p:r %<cr>:!%:p:r<cr>
augroup END

" nnoremap <silent> <F8> :!g++ -Wall % && ./a.out<cr>
"''''''''''''''' Theme '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
" lua <<EOF
"  vim.cmd.colorscheme "catppuccin-mocha"
" EOF

"''''''''''''''''''''Font Icons '''''''''''''''''''''''''''''''''''''''
set guifont=Hack\ Nerd\ Font\ 12
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"'''''''''''''LSP''''''''''''''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
-- require("mason-lspconfig").setup {
--     ensure_installed = {"rust_analyzer","jedi_language_server"},
-- }
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
   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
   vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
end     

require("lspconfig").jedi_language_server.setup {
    on_attach = on_attach 
    } 

EOF
"'''''''''''''''''''Bash lsp , installed trough dnf not plug '''''''''''
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
"''''''''''''''''''''Zero Lsp''''''''''''''''''''''''''''''''''''''''''
lua <<EOF
    local lsp = require('lsp-zero')
    lsp.preset('recommended')
    lsp.setup()
EOF
"'''''''''''''''''''Tree sitter highlight''''''''''''''''''''''''''''''
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
"''''''''''''''''''nvim-colorizer'''''''''''''''''''''''''''''''''''''
lua require'colorizer'.setup()

"'''''''''''''''''''Markdown Preview ''''''''''''''''''''''''''''''''''
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_browser = 'chromium-browser'

"''''''''''''''''''''''FloatTerm'''''''''''''''''''''''''''''''''''''''''''
let g:floaterm_keymap_toggle = '<F12>'
nnoremap <silent> <F9> :w<bar> :FloatermNew --autoclose=0 g++ -g -Wall % && ./a.out<cr>
nnoremap <silent> <F11> :w <bar> :FloatermNew --disposable --autoclose=0 python3 %<cr> 

"''''''''''''''''''''Airline Bar'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
set noshowmode 
set showtabline=2
let g:airline_section_z = airline#section#create(['%3p%% %L☰'])
let g:airline#extensions#tabline#enabled = 1
