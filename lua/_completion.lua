local status_ok1, cmp = pcall(require, "cmp")
local status_ok2, luasnip = pcall(require, "luasnip")
if not (status_ok1 or status_ok2) then
    return
end

local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

local function get_kind(kind_item)
    local prsnt, lspkind = pcall(require, "lspkind")
    if not prsnt then
        return kind_icons
    else
        return lspkind.presets.default[kind_item]
    end
end

local M = {}
M.config = function()
    for index, value in ipairs(vim.lsp.protocol.CompletionItemKind) do
        cmp.lsp.CompletionItemKind[index] = value
    end

    cmp.setup(
        {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s %s", get_kind(vim_item.kind), vim_item.kind)
                    vim_item.menu =
                        ({
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snp]",
                        -- buffer = "[Buf]",
                        nvim_lua = "[Lua]",
                        path = "[Pth]",
                        calc = "[Clc]",
                        emoji = "[Emj]"
                    })[entry.source.name]

                    return vim_item
                end
            },
            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm(
                    {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }
                ),
                -- ["<Tab>"] = function(fallback)
                --     if vim.fn.pumvisible() == 1 then
                --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
                --     elseif require("luasnip").expand_or_jumpable() then
                --         vim.fn.feedkeys(
                --             vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                --             ""
                --         )
                --     else
                --         fallback()
                --     end
                -- end,
                -- ["<S-Tab>"] = function(fallback)
                --     if vim.fn.pumvisible() == 1 then
                --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n")
                --     elseif require("luasnip").jumpable(-1) then
                --         vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                --     else
                --         fallback()
                --     end
                -- end
                ["<Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        vim.fn.feedkeys(
                            vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                            ""
                        )
                    else
                        fallback()
                    end
                end,
                ["<S-Tab>"] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                    else
                        fallback()
                    end
                end
            },
            sources = {
                {name = "nvim_lsp", keyword_length = 3},
                {name = "luasnip"},
                {name = "path"},
                -- {name = "buffer", keyword_length = 2},
                {name = "nvim_lua"}
            },
            experimental = {
                native_menu = false,
                ghost_text = false
            }
        }
    )

    -- Use buffer source for '/'
    cmp.setup.cmdline(
        "/",
        {
            sources = {
                {name = "buffer"}
            }
        }
    )

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(
        ":",
        {
            sources = cmp.config.sources(
                {
                    {name = "path"}
                },
                {
                    {name = "cmdline"}
                }
            )
        }
    )

    -- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    -- require("lspconfig")["sumneko_lua"].setup {
    --     capabilities = capabilities
    -- }
end

return M
