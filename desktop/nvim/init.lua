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
require('lspConfig')
require('cmpConf')


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

-- treat qss as css
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.qss",
  command = "set filetype=css"
})



-- set spelling on these files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})


vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Auto-open the preview window whenever Oil finishes rendering
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = function()
    require("oil").open_preview()
  end,
})


--############
--# setup   #
--###########


-- telescope
require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            },
        },
    },
}

require("telescope").load_extension("ui-select")


-- ''''''''''Splash''''''''''''''''''''''''''''''''''''''''''''''''''''
require('customSplash')

--''''''''''''''''''''''''My snippets''''''''''''''''''''''''''''''''''
require("lsnip")

--"''''''''''''''''''nvim-colorizer'''''''''''''''''''''''''''''''''''''
require'colorizer'.setup()
-- this is an autocomand to force colorizer to attach to some files
vim.api.nvim_exec([[
augroup ColorizerAttach
autocmd!
autocmd BufRead,BufNewFile *.config,*.rasi,*.conf,*.qss,*.css :ColorizerAttachToBuffer
augroup END
]], false)

--'''''''''''''' Theme ''''''''''''''''''''''''''''''''''''''''''''''''
local function force_backgraund(color)
    color = color or "catppuccin-mocha"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal",{bg = "none"} )
    vim.api.nvim_set_hl(0, "NormalFloat",{bg = "none"} )
end
force_backgraund()


--"''''''''Neotree''''''''''''''''''''''''''''''''''''''''''''''''''''''''
require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
        hijack_netrw_behavior = "disabled"
    },
    window = {
        width = 25
    },
})


--'''''''''''''nvim-ts-autotag'''''''''''''''''''''''''''''''''''''''''
require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
    },
})



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

-- '''''''''''' highlight ''''''''''''''''''''''''''''''''''''''''
require('local-highlight').setup({ animate = { enabled = false}})


--'''''''''''''''OIL'''''''''''''''''''''''''''''''''''''''''''''''
require("oil").setup({
    default_file_explorer = true,
    keymaps = {
        ["?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["H"] = { "actions.toggle_hidden", mode = "n" },
    },
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false,
    },
    float = {
        preview_split = "right",
    },
    preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
    },

})

-- ''''''''''''''autopairs'''''''''''''''''''''''''''''''''''''''
local npairs = require("nvim-autopairs")
npairs.setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    },
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey='Comment'
    },
})

local cmp = require'cmp'
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

