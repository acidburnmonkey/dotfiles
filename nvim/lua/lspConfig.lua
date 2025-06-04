
--"''''''''''''''''''''Zero Lsp''''''''''''''''''''''''''''''''''''''''''
local lsp = require('lsp-zero')
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

--"'''''''Mason''''''''''''''''''''''''''''''''''''''''''''''''''''''
require("mason").setup({
ui = {
    icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
    }
    }
})

local servers = {"clangd", "ts_ls", "pyright", "tailwindcss",'html' ,'stimulus_ls','cssls','lua_ls'}
require("mason-lspconfig").setup {
    ensure_installed = servers,
}


--shortcuts
local lsp_attach = lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
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


lsp.on_attach(lsp_attach)
lsp.default_capabilities = capabilities
lsp.setup()

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
            globals = { 'vim' ,'require'}
        }
    }
} }

--ts_ls
require("lspconfig").ts_ls.setup{
  settings = {
    -- implicitProjectConfiguration = {
    --   checkJs = true
    -- },
  }
}

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
