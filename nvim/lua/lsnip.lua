local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Keybindings for LuaSnip jumping (forward)
vim.keymap.set({"i", "s"}, "<C-j>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").jump(1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-l>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").jump(1)
    end
end, {silent = true})

-- Keybindings for LuaSnip jumping (backward)
vim.keymap.set({"i", "s"}, "<C-k>", function()
    if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-h>", function()
    if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
    end
end, {silent = true})


ls.config.set_config {
    history = true,
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 200,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = false,
    store_selection_keys = "<TAB>",
}




-- Define shared snippets js, ts, jsx,tsx
local common_snippets = {
    s("soto", {
        t('console.log('),
        i(1),
        t(')')
    }),

    s("fore", {
        i(1),
        t(".forEach(item => {"),
        t({"", "    "}),
        i(0),
        t({"", "})"})
    }),

    s("for", {
        t("for (let i = 0; i < "),
        i(1, 'array'),
        t('.length; i++) {'),
        t({"", "    "}),
        i(2),
        t({"", "}"})
    })
}

-- Filetypes to apply snippets to
local filetypes = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact"
}

-- Apply snippets to each filetype
for _, ft in ipairs(filetypes) do
    ls.add_snippets(ft, common_snippets)
end


-- Markdown
-- ls.add_snippets("markdown",{
-- })







