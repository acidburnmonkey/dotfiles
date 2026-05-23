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
			package_uninstalled = "✗",
		},
	},
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
	bufmap("n", "K", function()
		vim.lsp.buf.hover({
			border = "rounded",
		})
	end, "Show hover documentation")
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
local servers = {
	"clangd",
	"vtsls",
	"pyright",
	"tailwindcss",
	"html",
	"stimulus_ls",
	"cssls",
	"gopls",
	"autotools-language-server",
}

------Uncoment on first run
-- require("mason-lspconfig").setup({
--   ensure_installed = servers,
-- })

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
		on_attach = lsp_attach,
	})
	vim.lsp.enable(server)
end

vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = lsp_attach,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				stubPath = "",
				diagnosticMode = "off",
				autoImportCompletions = true,
			},
		},
	},
})
vim.lsp.enable("pyright")

----------- RUFF
vim.lsp.config("ruff", {
	filetypes = { "python" },
	init_options = {
		settings = {
			configuration = "~/.config/ruff/pyproject.toml",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

vim.lsp.enable("ruff")

--------- django experimental
vim.lsp.config("djls", {
	cmd = { "djls", "serve" },
	filetypes = { "htmldjango", "html", "python" },
	root_markers = { "manage.py" },
})

vim.lsp.enable("djls")

-------------- LUA
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = lsp_attach,

	settings = {
		Lua = {
			workspace = {
				library = {
					"/usr/share/hypr/stubs",
					-- Neovim Lua runtime completion
					vim.env.VIMRUNTIME,
					-- Your nvim config Lua files
					vim.fn.stdpath("config") .. "/lua",
				},
				checkThirdParty = false,
			},
			diagnostics = {
				enable = true,
				globals = { "vim", "hl" },
			},
		},
	},
})

vim.lsp.enable("lua_ls")

--''''''''''''''''Non-ls/null-ls''''''''''''''''
local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

local ruff_format = helpers.make_builtin({
	name = "ruff_format",
	method = methods.internal.FORMATTING,
	filetypes = { "python" },
	generator_opts = {
		command = "ruff",
		args = { "format", "--stdin-filename", "$FILENAME", "-" },
		to_stdin = true,
	},
	factory = helpers.formatter_factory,
})

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.djlint,
		null_ls.builtins.diagnostics.cppcheck,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.hadolint,
		null_ls.builtins.formatting.prettierd.with({ extra_args = { "--single-quote" } }),
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.stylua,
		ruff_format,
	},
	on_attach = function(client, bufnr)
		if client:supports_method("textDocument/formatting") then -- run formatters on save
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
require("nvim-treesitter").install({ "lua", "bash", "python", "typescript", "javascript", "go" })

local ts_indent_langs = { "html", "javascript", "tsx", "go", "lua" }
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		pcall(vim.treesitter.start)
		if vim.tbl_contains(ts_indent_langs, ev.match) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = false,
	},
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope", "locals") end)

vim.keymap.set({ "n", "x", "o" }, "<C-f>", function() move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "<A-f>", function() move.goto_previous_start("@function.outer", "textobjects") end)
