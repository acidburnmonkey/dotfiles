
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

    -- Terminal floating window
    { "voldikss/vim-floaterm" },

    -- Markdown Preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- Color highlighting
    { "norcalli/nvim-colorizer.lua" },

    -- Undo tree viewer
    { "mbbill/undotree" },

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
        lazy = false,
        opts = { },
    },


    -- Telescope fuzzy finder
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },


    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },


    -- Mason package manager
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },


    -- LuaSnip engine
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
    },
    -- LuaSnip snippets
    { "rafamadriz/friendly-snippets" },

    -- Autopairs
    { "jiangmiao/auto-pairs" },

    -- Commenting utility
    { "tpope/vim-commentary" },

    -- Catppuccin theme
    { "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000 },

    -- Surround plugin
    { "tpope/vim-surround" },

    -- Git integration
    { "tpope/vim-fugitive" },

    -- Formatter/Linter integration
    { "nvimtools/none-ls.nvim" ,
        dependencies = {
        "nvimtools/none-ls-extras.nvim",},
    } ,

    -- Treesitter auto-closing tags
    { "windwp/nvim-ts-autotag" },

    -- Signature marks
    { "kshenoy/vim-signature" },

    -- Oil file explorer
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
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
    { 'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' } },

    -- File icons
    { "ryanoasis/vim-devicons" },

    -- barbar
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        init = function()
            vim.g.barbar_auto_setup = false -- disable auto-setup
        end,
        opts = {},
    },
-- highlight
  {
      'tzachar/local-highlight.nvim',
  },


{
    'ChuufMaster/buffer-vacuum',
    opts = {
      max_buffers = 2,
      count_pinned_buffers = false,
      enable_messages = false,
    },
  },
}

local opts = {}

require('lazy').setup(plugins, opts)

