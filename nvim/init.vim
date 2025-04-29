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
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
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
"''''''''''''''''''''''''''''''''''''''''''''''''''''''

call plug#end()


"##########
"LUA Block#
"##########
lua <<EOF

-- General settings
require('options')
-- keymaps
require('keymaps')

-- Luasnip
require("luasnip.loaders.from_vscode").lazy_load()
-- Code runners 
require('coderun')
--plugin short settings
require('pluginSettings')



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
    null_ls.builtins.formatting.prettierd.with({
      extra_args = { "--single-quote" },
    }),
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
      local enabled_langs = { "html", "javascript", "tsx" } -- Enable auto indent only for these languages
      return not vim.tbl_contains(enabled_langs, lang)
    end,
  },
auto_install = true,
highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      include_surrounding_whitespace = true,
    },
move = {
  enable = true,
  set_jumps = true,
  goto_next_start = {
    ["<C-f>"] = "@function.outer", -- jump to next function
  },
  goto_previous_start = {
    ["<A-f>"] = "@function.outer", -- jump to previous function
  },
},
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
        behavior = cmp.ConfirmBehavior.Insert,
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


EOF
