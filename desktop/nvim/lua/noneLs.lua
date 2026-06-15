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

local rustfmt_format = helpers.make_builtin({
	name = "rustfmt_format",
	method = methods.internal.FORMATTING,
	filetypes = { "rust" },
	generator_opts = {
		command = "rustfmt",
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
		rustfmt_format,
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
