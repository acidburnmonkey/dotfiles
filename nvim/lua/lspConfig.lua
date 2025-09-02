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


-- Define capabilities for LSP servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LSP attach callback
local lsp_attach = function(client, bufnr)
  -- Helper function to set buffer-local keymaps
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Keymaps for LSP actions
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  bufmap("n", "K", vim.lsp.buf.hover, "Show hover documentation")
  bufmap("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Search workspace symbols")
  bufmap("n", "<leader>vd", vim.diagnostic.open_float, "Show diagnostics in float")
  bufmap("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
  bufmap("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  bufmap("n", "gr", vim.lsp.buf.references, "Find references")
  bufmap("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
  bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Show signature help")
end

-- Mason-LSPconfig setup
local servers = { "clangd", "ts_ls", "pyright", "tailwindcss", "html", "stimulus_ls", "cssls", "lua_ls"}

------Uncoment on first run
-- require("mason-lspconfig").setup({
--   ensure_installed = servers,
-- })

local lspconfig = require("lspconfig")

-- Setup LSP servers dynamically
for _, server in ipairs(servers) do
    lspconfig[server].setup({
            capabilities = capabilities,
            on_attach = lsp_attach
        })
    end


-- r
lspconfig.r_language_server.setup({
        capabilities = capabilities,
        on_attach = lsp_attach

})


local util = require("lspconfig.util")
require('lspconfig').pyright.setup{
    capabilities = capabilities,
    on_attach = lsp_attach,
    root_dir  = util.root_pattern(
        'pyproject.toml',
        'requirements.txt',
        '.git'
    ),
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                stubPath = "",
                diagnosticMode  = 'off',
                autoImportCompletions = true,
            },
        },
    },
}

-- RUFF
vim.lsp.config('ruff', {
  init_options = {
    settings = {
      configuration = "~/.config/ruff/pyproject.toml"
    }
  }
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

vim.lsp.enable('ruff')


--''''''''''''''''Non-ls/null-ls''''''''''''''''
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.cppcheck,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.hadolint,
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
ensure_installed = { "lua","bash","python",'typescript','javascript','go'},
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
      include_surrounding_whitespace = false,
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
