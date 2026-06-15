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
	bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	bufmap("n", "gr", vim.lsp.buf.references, "Find references")
	bufmap("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
	bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Show signature help")
	bufmap("n", "<F1>", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
	end, "Toggle inlay hints")

	-- Turn inlay hints on automatically, but only for these filetypes
	local inlay_hint_filetypes = { go = true, cpp = true, rust = true }
	if client:supports_method("textDocument/inlayHint") and inlay_hint_filetypes[vim.bo[bufnr].filetype] then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- Mason-LSPconfig setup
local servers = {
	"lua_ls",
	"clangd",
	"vtsls",
	"pyright",
	"tailwindcss",
	"html",
	"stimulus_ls",
	"cssls",
	"yamlls",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false,
})

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
		on_attach = lsp_attach,
	})
	vim.lsp.enable(server)
end

-- rust
vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	on_attach = lsp_attach,
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				bindingModeHints = { enable = false },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				closureReturnTypeHints = { enable = "never" },
				lifetimeElisionHints = { enable = "never", useParameterNames = false },
				maxLength = 25,
				parameterHints = { enable = true },
				reborrowHints = { enable = "never" },
				renderColons = true,
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
		},
	},
})
vim.lsp.enable("rust_analyzer")

-- GOPLS
vim.lsp.config("gopls", {
	capabilities = capabilities,
	on_attach = lsp_attach,
	settings = {
		gopls = {
			hints = {
				parameterNames = true,
				-- assignVariableTypes = true,
				-- compositeLiteralFields = true, -- {/* in: */ "hello", /* want: */ "world"}
				-- compositeLiteralTypes = true,
				-- constantValues = true,
				functionTypeParameters = true,
				-- rangeVariableTypes = true,
			},
		},
	},
})

vim.lsp.enable("gopls")

--- pyright
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
