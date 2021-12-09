-- this is not even used. REMOVE if not needed
local present, luasnip = pcall(require, "luasnip")
if not present then
    return
end

-- local ls = require "luasnip"
local ls = luasnip
local s = ls.s -- Snippet
local t = ls.t -- Text
local i = ls.i -- Input
local f = ls.f -- Function

ls.config.set_config(
    {
        history = true,
        updateevents = "TextChanged,TextChangedI"
    }
)

ls.snippets = {
    all = {
        ls.parser.parse_snippet({trig = "todo"}, "TODO(zootedb0t): ${1:todo}"),
        ls.parser.parse_snippet({trig = "fixme"}, "FIXME(zootedb0t): ${1:fixme}"),
        s({trig = "date"}, {t({vim.fn.strftime("%F-%T")})})
    }
}

-- require("luasnip/loaders/from_vscode").load()
