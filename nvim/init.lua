
require('plugins')
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

--############
-- # Autorun #
-- ###########

-- remove_trailing_whitespace  on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    require('functions').remove_trailing_whitespace()
  end,
})



--"''''''''''''''''''''Zero Lsp''''''''''''''''''''''''''''''''''''''''''
local lsp = require('lsp-zero')
lsp.setup()

--"''''''''''''''''''nvim-colorizer'''''''''''''''''''''''''''''''''''''
require'colorizer'.setup()
-- this is an autocomand to force colorizer to attatch to some files
vim.api.nvim_exec([[
    augroup ColorizerAttach
        autocmd!
        autocmd BufRead,BufNewFile *.config,*.rasi,*.conf :ColorizerAttachToBuffer
    augroup END
]], false)

--'''''''''''''' Theme ''''''''''''''''''''''''''''''''''''''''''''''''
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

local servers = {"clangd", "ts_ls", "pyright", "tailwindcss",'html','stimulus_ls','cssls','lua_ls'}
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


--cssls
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, server in ipairs(servers) do
    require("lspconfig")[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end


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


-- lua_ls
require'lspconfig'.lua_ls.setup{settings = {
    Lua = {
        diagnostics = {
            globals = { 'vim' }
        }
    }
} }



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
ensure_installed = { "c", "lua","bash","python"},
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

--'''''''''''''''''' web-devicons ''''''''''''''''''''''''''''''''''
require('nvim-web-devicons').setup{}



--"''''''''''IndentBlankline''''''''''``````````````````````````````````
require("ibl").setup()

-- '''''''''''''' cmp  ''''''''''''''''''''''''''''''''''''''''''''''''
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

-- highlight function off default
require("highlight")
--''''''''''''''''''''''''My snippets''''''''''''''''''''''''''''''''''
require("lsnip")

--''''''''''''''''''''''''rainbow'''''''''''''''''''''''''''''''''''''''
require('rainbow-delimiters.setup').setup {
    strategy = {
    },
    query = {
    },
    highlight = {
    },
}

--''''''''''Lualine''''''''''''''''''''''''''''''''''''''''''''''''''''
require('lualine').setup {
  options = {
   theme = 'catppuccin',
    icons_enabled = true,
    component_separators = { left = ' ', right = ' ' },
    section_separators = { left = '|', right = '|' },
    globalstatus = true,
  },

  sections = {
    lualine_z = {
      function()
        local line = vim.fn.line('.')
        local total = vim.fn.line('$')
        local percent = math.floor((line / total) * 100)
        return string.format("%3d%%%% %d☰", percent, total)
      end
    }
  }
}

--'''''''''Barbar'''''''''''''''''''''''''''''''''''''''''''''''''''
require('barbar').setup({
  animation = false,
  auto_hide = 1,
  tabpages = false,
  clickable = true,
  icons = {
    buffer_index = true,
    buffer_number = false,
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
      [vim.diagnostic.severity.WARN] = { enabled = true, icon = ' ' },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
    },
    filetype = {
      enabled = true,
    },
    separator = { left = '▎', right = '' },
    modified = { button = '●' },
    pinned = { button = '車', filename = true },
  },
})



