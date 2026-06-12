-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

	{ "neovim/nvim-lspconfig" },

	-- mine
	{
		"acidburnmonkey/ruffer",
		config = function()
			require("ruffer").setup()
		end,
	},

	-- Terminal floating window
	{ "voldikss/vim-floaterm" },

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		opts = {},
	},

	-- Color highlighting
	{ "catgoose/nvim-colorizer.lua", event = "BufReadPre" },

	-- Undo tree viewer
	{ "mbbill/undotree", cmd = "UndotreeToggle" },

	-- Devicons
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- Neo-tree file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = true,
	},

	-- Telescope fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

	-- Mason package manager
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = {},
	},

	-- mason-lspconfig
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	-- LuaSnip engine
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
	},

	-- Commenting utility
	{ "tpope/vim-commentary" },

	-- Catppuccin theme
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Surround plugin
	{ "tpope/vim-surround" },

	-- Formatter/Linter integration
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
	},

	-- Treesitter auto-closing tags
	{ "windwp/nvim-ts-autotag", ft = { "html", "jsx", "tsx", "svelte", "vue", "xml" } },

	-- Signature marks
	{ "kshenoy/vim-signature" },

	-- Oil file explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
	},

	-- Rainbow delimiters
	{ "HiPhish/rainbow-delimiters.nvim" },

	-- Completion engine
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },

	-- Lualine
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- barbar
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false -- disable auto-setup
		end,
	},

	-- highlight
	{
		"tzachar/local-highlight.nvim",
		event = "BufReadPost",
	},

	-- buffer vacuum
	{
		"ChuufMaster/buffer-vacuum",
		opts = {
			max_buffers = 2,
			count_pinned_buffers = false,
			enable_messages = false,
		},
	},

	-- telescope plugin
	{ "nvim-telescope/telescope-ui-select.nvim" },

	-- harpoon
	{ "ThePrimeagen/harpoon", lazy = false },

	--MarkdownPreview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- Dadbod
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	-- go-tagger
	{
		"romus204/go-tagger.nvim",
		ft = { "go" },
		config = function()
			require("go-tagger").setup({
				skip_private = true,
				casing = "camelCase",
				tags = {
					json = {
						casing = "camelCase",
					},
					xml = {
						casing = "snake_case",
					},
				},
			})
		end,
	},

	-- lazy.nvim
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = { border = "rounded" },
			doc_lines = 0, -- show only the signature, no documentation
			hint_enable = false,
			hint_prefix = "🐾 ",
			floating_window = true,
			auto_close_after = nil,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
}

local opts = {}

require("lazy").setup(plugins, opts)
