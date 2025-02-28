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
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
"############
"#   Pugins #
"############

call plug#begin()

Plug 'rust-lang/rust.vim'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'voldikss/vim-floaterm'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'lukas-reineke/indent-blankline.nvim'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'norcalli/nvim-colorizer.lua'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'mbbill/undotree'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'MunifTanjim/nui.nvim'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
""''''''''''''''''''''''''''''''''''''''''''''''"''''''''''''''''''
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
"""""""""""""""""""""""""""'''''''''''''''''''''''''''''''''''""""
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-jedi'
""''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'gennaro-tedesco/nvim-peekup'
""''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
""''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'tpope/vim-surround'
""'''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'ryanoasis/vim-devicons'
""''''''''''''''''''''''''''''''''''''''''''''''''''
"" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'VonHeikemen/lsp-zero.nvim'
"" ''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"" ''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'tpope/vim-fugitive'
""''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'nvimtools/none-ls.nvim'
""''''''''''''''''''''''''''''''''''''''''''''
Plug 'windwp/nvim-ts-autotag'
"''''''''''''''''''''''''''''''''''''''''''''''
Plug 'kshenoy/vim-signature'
"''''''''''''''''''''''''''''''''''''''''''''''
Plug 'stevearc/oil.nvim'
"''''''''''''''''''''''''''''''''''''''''''''''
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} 
"''''''''''''''''''''''''''''''''''''''''''''''''''''''
Plug 'HiPhish/rainbow-delimiters.nvim'

call plug#end()

"#####################
"     Remaps         #
"#####################

" nnoremap \ :Neotree focus<cr>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>- :IBLToggle<CR>
let g:peekup_open = '<F5>'
" let g:peekup_paste_after = '<leader>0'
map <leader>0 "*p

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
" autocmd VimEnter * WipeReg

"closes all buffers but current 
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <leader>b :BufOnly<CR>
"Remove all trailing whitespace by pressing F2
nnoremap <F2> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

lua <<EOF
vim.keymap.set("n", "<leader><TAB>", ":bnext<CR>") -- Tab next 
vim.keymap.set("n", "x", [["_x]]) --void x
vim.keymap.set("n", "E", "ge") -- go back
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move block
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") --  move block
vim.keymap.set("n", "<leader>r", [[:%s#\<<C-r><C-w>\>#<C-r><C-w>#gI<Left><Left><Left>]]) -- global remap
vim.api.nvim_set_keymap('v', '<Leader>r', ':<C-U>call ReplaceWordUnderCursorInSelection()<CR>', { noremap = true, silent = true }) -- visual remap
vim.keymap.set("x", "p", [["_dP]]) -- void paste 
vim.keymap.set("n", "J", "mzJ`z") -- append line
vim.keymap.set("n", "<C-d>", "<C-d>zz") --move half page
vim.keymap.set("n", "<C-u>", "<C-u>zz") --move half page
vim.api.nvim_set_keymap('x', 'W', 'iW', { noremap = true, silent = true }) -- remaps viW to just vW


--telescope
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>")
vim.keymap.set('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>")
vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")

vim.cmd([[nnoremap \ :Neotree toggle<cr>]])
vim.opt.hlsearch = false

-- To avoid neotree from crashing all vim, closes the tab
local bufremove = require('bufremove')
vim.keymap.set("n", "<leader>q", bufremove.bufremove, { desc = "Delete buffer" })

EOF

"#####################
"#     Configs       # 
"#####################

"''''''''''''''''''' Markdown Preview ''''''''''''''''''''''''''''''''''
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_browser = 'chromium-browser'

"''''''''''''Coding'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
" let g:deoplete#enable_at_startup = 1

"'''''''''''''''''''''''''''''''''LuaSnip'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
" imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
lua require("luasnip.loaders.from_vscode").lazy_load()
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python map <buffer> <F10> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F10> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

autocmd FileType javascript map <buffer> <F10> :w<CR>:exec '!node' shellescape(@%, 1)<CR>
autocmd FileType javascript imap <buffer> <F10> <esc>:w<CR>:exec '!node' shellescape(@%, 1)<CR>

autocmd FileType sh map <buffer> <F10> :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
autocmd FileType sh imap <buffer> <F10> <esc>:w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
autocmd filetype cpp nnoremap <buffer> <F10> :!g++ -o %:p:r %<cr>:!%:p:r<cr>
autocmd FileType rust nmap <F10> :w<CR>:!rustc % -o %:r && ./%:r<CR>

"" nnoremap <silent> <F8> :!g++ -Wall % && ./a.out<cr>
"''''''''''''''' Theme '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
" lua  vim.cmd.colorscheme "catppuccin-mocha"

"''''''''''''''''''''Airline Bar'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme='catppuccin'
set noshowmode 
set showtabline=2
let g:airline_section_z = airline#section#create(['%3p%% %L☰'])
let g:airline#extensions#tabline#enabled = 1

"''''''''''''''''''''''FloatTerm'''''''''''''''''''''''''''''''''''''''''''
let g:floaterm_keymap_toggle = '<F12>'
autocmd filetype cpp nnoremap <silent> <F9> :w<bar> :FloatermNew --autoclose=0 g++ -g -Wall % && ./a.out<cr>
autocmd FileType python nnoremap <silent> <F11> :w <bar> :FloatermNew --disposable --autoclose=0 python3 %<cr> 
autocmd FileType rust nnoremap <silent> <F11> :w <bar> :FloatermNew --disposable --autoclose=0 rustc % -o %:r && ./%:r<CR>
autocmd FileType cpp nnoremap <silent> <F11> :w <bar> :FloatermNew --disposable --autoclose=0 g++ -o %:p:r % <bar> /%:p:r<CR>
autocmd FileType javascript nnoremap <silent> <F11> :w <bar> :FloatermNew --disposable --autoclose=0 node %<cr> 

"''''''''''''''''''''Font Icons '''''''''''''''''''''''''''''''''''''''
" set guifont=FiraCodeNerdFont-Regular
let g:WebDevIconsUnicodeDecorateFolderNodes = 1


"##########
"LUA Block#
"##########
lua <<EOF

--"''''''''''''''''''''Zero Lsp''''''''''''''''''''''''''''''''''''''''''
local lsp = require('lsp-zero')
lsp.setup()
-- Define capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

--"''''''''''''''''''nvim-colorizer'''''''''''''''''''''''''''''''''''''
require'colorizer'.setup()
-- this is an autocomand to force colorizer to attatch to some files
vim.api.nvim_exec([[
    augroup ColorizerAttach
        autocmd!
        autocmd BufRead,BufNewFile *.config,*.rasi,*.conf :ColorizerAttachToBuffer
    augroup END
]], false)

--"'''''''''''Force transparency if no compositor installed'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    function force_backgraund(color)
        color = color or "catppuccin-mocha"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal",{bg = "none"} )
        vim.api.nvim_set_hl(0, "NormalFloat",{bg = "none"} )
    end
force_backgraund()

--"'''''''LSP''''''''''''''''''''''''''''''''''''''''''''''''''''''

require("mason").setup({
ui = {
    icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
    }
    }
})

local servers = {"clangd", "ts_ls", "pyright", "tailwindcss",'html','stimulus_ls','cssls'}
require("mason-lspconfig").setup {
    ensure_installed = servers,
}


--shortcuts
lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.document_highlight,  opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.clear_references,  opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
    end)

--require("lspconfig").jedi_language_server.setup {
--    on_attach = on_attach, 
--    capabilities = capabilities
--    } 

--cssls
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, server in ipairs(servers) do
    require("lspconfig")[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

  
 -- require'lspconfig'.cssls.setup {
   -- capabilities = capabilities,
  --}

--"'''''''''''''''''''Bash lsp , installed trough dnf not plug '''''''''''
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})


--''''''''''''''''Non-ls/null-ls''''''''''''''''
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.cppcheck,
        -- null_ls.builtins.diagnostics.semgrep, --jsx and others
        null_ls.builtins.formatting.prettierd.with({  -- Enforce single quotes
        extra_args = { "--single-quote" }     }), 
        -- null_ls.builtins.diagnostics.pylint.with({
        --extra_args = { "--disable=C" }  }),
        --null_ls.builtins.completion.spell,
        },
    on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end,
})

--"'''''''''''''''''''Tree sitter highlight''''''''''''''''''''''''''''''
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
ensure_installed = { "c", "lua", "rust","bash","python"},
sync_install = false,
indent = {
    enable = true,
    disable = function(lang, bufnr)
      local enabled_langs = { "html", "javascript", "tsx" } -- Enable indent only for these languages
      return not vim.tbl_contains(enabled_langs, lang)
    end,
  },
auto_install = true,
highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
                    
--"''''''''Neotree''''''''''''''''''''''''''''''''''''''''''''''''''''''''
require("neo-tree").setup({
        close_if_last_window = true,
})

--"nvim-web-devicons'''''''''''''''''''''''''''''''''''''''''''''''''''''
require('web-devicons')


--"''''''''''IndentBlankline''''''''''``````````````````````````````````
require("ibl").setup()

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    
    mapping = {
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
        })
        }, 

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
       { name = 'luasnip' }, -- For luasnip users.
         { name = 'path' }      
        }, 
    {
      { name = 'buffer' },
    })
  })

--'''''''''''''nvim-ts-autotag'''''''''''''''''''''''''''''''''''''''''
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
})


--'''''''''''''''OIL'''''''''''''''''''''''''''''''''''''''''''''''
require("oil").setup({
lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = false,
    }
})

require("highlight")
--''''''''''''''''''''''''My snippets''''''''''''''''''''''''''''''''''
require("lsnip")

--''''''''''''''''''''''''rainbow'''''''''''''''''''''''''''''''''''''''
require('rainbow-delimiters.setup').setup {
    strategy = {
        -- ...
    },
    query = {
        -- ...
    },
    highlight = {
        -- ...
    },
}


-- ###########
-- #Functions#
-- ###########

-- Function to replace the word under the cursor in the selected lines
vim.cmd([[
function! ReplaceWordUnderCursorInSelection()
    let l:current_pos = getpos(".")
    normal! gv
    let l:word = expand("<cword>")
    let l:replacement = input("Replace '" . l:word . "' with: ")
    call setpos('.', l:current_pos)
    if !empty(l:replacement)
        let l:start = line("'<")
        let l:end = line("'>")
        execute l:start . "," . l:end . "s/" . l:word . "/" . l:replacement . "/g"
    endif
endfunction
]])


EOF
