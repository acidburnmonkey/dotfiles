
-- luasnip.lua
local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

-- Keybindings for LuaSnip jumping
vim.keymap.set({"i", "s"}, "<Tab>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").jump(1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<S-Tab>", function()
    if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
    end
end, {silent = true})


--js
ls.add_snippets("javascript",{
    s("soto",{
        t('console.log('),
        i(1),
        t(')')
    })
})

ls.add_snippets("javascript",{
    s("fore", {
        i(1),
        t(".forEach(item => {"),
        t({"", "    "}),
        i(0),
        t({"", "})"})
    })
})

ls.add_snippets("javascript",{
    s("for", {
        t("for (let i =0; i <"),
        i(1,'array'),
        t('.lenght ; i++){'),
        t({"", "    "}),
        i(2),
        t({"", "}"})
    })
})

--react
ls.add_snippets("javascriptreact",{
    s("fore", {
        i(1),
        t(".forEach(item => {"),
        t({"", "    "}),
        i(0),
        t({"", "})"})
    })
})

ls.add_snippets("javascriptreact",{
    s("sot",{
        t('console.log('),
        i(1),
        t(')')
    })
})

ls.add_snippets("javascriptreact",{
    s("for", {
        t("for (let i =0; i <"),
        i(1,'array'),
        t('.lenght ; i++){'),
        t({"", "    "}),
        i(2),
        t({"", "}"})
    })
})

