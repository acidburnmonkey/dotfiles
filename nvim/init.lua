
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




-- ''''''''''Splash''''''''''''''''''''''''''''''''''''''''''''''''''''
require('customSplash')

--''''''''''''''''''''''''My snippets''''''''''''''''''''''''''''''''''
require("lsnip")

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

--"''''''''Neotree''''''''''''''''''''''''''''''''''''''''''''''''''''''''
require("neo-tree").setup({
    close_if_last_window = true,
})

--'''''''''''''''''' web-devicons ''''''''''''''''''''''''''''''''''
require('nvim-web-devicons').setup{}

--"''''''''''IndentBlankline''''''''''``````````````````````````````````
require("ibl").setup()

-- '''''''''''''' cmp ''''''''''''''''''''''''''''''''''''''''''''''''
-- Set up nvim-cmp.
local cmp = require'cmp'

local kind_icons = {
    Text = " ",
    Method = " ",
    Function = " ",
    Constructor = " ",
    Field = " ",
    Variable = " ",
    Class = " ",
    Interface = " ",
    Module = " ",
    Property = " ",
    Unit = " ",
    Value = " ",
    Enum = " ",
    Keyword = " ",
    Snippet = " ",
    Color = " ",
    File = " ",
    Reference = " ",
    Folder = " ",
    EnumMember = " ",
    Constant = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
}


cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    formatting = {
        format = function(_, vim_item)
            vim_item.kind = (kind_icons[vim_item.kind] or '') .. vim_item.kind
            return vim_item
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
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),

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

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
