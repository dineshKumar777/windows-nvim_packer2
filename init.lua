--https://gitee.com/sternelee/neovim-nvim/blob/master/init.lua

--
local cmd = vim.cmd
local g = vim.g

-- Settings
local scopes = {
    o = vim.o,
    b = vim.bo,
    w = vim.wo
}
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

local indent = 4
opt("b", "expandtab", true) -- Use spaces instead of tabs
opt("b", "shiftwidth", indent) -- Size of an indent
opt("b", "smartindent", true) -- Insert indents automatically
opt("b", "tabstop", indent) -- Number of spaces tabs count for
opt("o", "completeopt", "menuone,noselect") -- Completion options (for compe)
opt("o", "pumheight", 10) -- Enable modified buffers in background
opt("o", "hidden", true) -- Enable modified buffers in background
opt("o", "scrolloff", 3) -- Lines of context
opt("o", "shiftround", true) -- Round indent
opt("o", "sidescrolloff", 8) -- Columns of context
opt("o", "smartcase", true) -- Don't ignore case with capitals
opt("o", "ignorecase", true) -- Don't ignore case with capitals
opt("o", "splitbelow", true) -- Put new windows below current
opt("o", "splitright", true) -- Put new windows right of current
opt("o", "termguicolors", true) -- True color support
opt("o", "wildmode", "list:longest") -- Command-line completion mode
-- opt("o", "clipboard", "unnamed")
opt("o", "pumblend", 25)
opt("o", "scrolloff", 2)
opt("o", "swapfile", false)
opt("o", "showmode", false)
opt("o", "backup", false)
opt("w", "number", true) -- Print line number
opt("o", "lazyredraw", false)
opt("o", "signcolumn", "yes")
opt("o", "mouse", "a")
opt("o", "cmdheight", 1)
opt("o", "wrap", false)
opt("o", "relativenumber", false)
opt("o", "hlsearch", true)
opt("o", "inccommand", "split")
opt("o", "smarttab", true)
opt("o", "incsearch", true)

--set shortmess
vim.o.shortmess = vim.o.shortmess .. "c"

--mappings
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.mapleader = " "
map("n", ";", ":") --semicolon to enter command mode
map("v", ";", ":") --semicolon to enter command mode
map("n", "<f7>", "gg=G<C-o>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>s", "<cmd>w<CR>")
map("n", "<leader>x", "<cmd>qa!<CR>")
map("n", "<leader><leader>", "<cmd>b#<CR>")

-- Paste next or above in normal mode
map("n", "<leader>p", "m`o<ESC>p``")
map("n", "<leader>P", "m`O<ESC>p``")

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap =
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(
    function(use)
        use {
            "wbthomason/packer.nvim"
        }
        use "nathom/filetype.nvim"
        use(
            {
                "catppuccin/nvim",
                as = "catppuccin",
                config = function()
                    require("_catppuccin")
                    vim.cmd [[colorscheme catppuccin]]
                end
            }
        )
        -- use {
        --     "lifepillar/vim-gruvbox8",
        --     config = function()
        --         vim.g.gruvbox_italics = 1
        --         vim.g.gruvbox_italicize_strings = 1
        --         vim.g.gruvbox_filetype_hi_groups = 0
        --         vim.g.gruvbox_plugin_hi_groups = 1
        --         vim.cmd [[colorscheme gruvbox8_soft]]
        --     end
        -- }
        use {
            "kyazdani42/nvim-web-devicons"
        }
        -- lualine is adding more sourcing time to first screen update
        -- use {
        --     "nvim-lualine/lualine.nvim",
        --     after = "nvim-web-devicons",
        --     config = function()
        --         require("lualine").setup {
        --             options = {
        --                 theme = "auto"
        --             },
        --             extensions = {
        --                 "toggleterm"
        --             }
        --         }
        --     end
        -- }
        -- mkdir
        use {
            "jghauser/mkdir.nvim",
            event = "CmdlineEnter",
            config = function()
                require("mkdir")
            end
        }
        use {
            "akinsho/toggleterm.nvim",
            cmd = {"ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll"},
            keys = "<c-t>",
            config = function()
                require("toggleterm").setup {
                    open_mapping = [[<c-t>]]
                }
            end
        }
        use {
            "kyazdani42/nvim-tree.lua",
            requires = "kyazdani42/nvim-web-devicons",
            cmd = {"NvimTreeToggle", "NvimTreeFocus"},
            config = function()
                require("nvim-tree").setup()
            end
        }
        use {
            "rhysd/clever-f.vim",
            keys = "f",
            config = function()
                vim.g.clever_f_across_no_line = 1
                vim.g.clever_f_smart_case = 1
                vim.g.clever_f_fix_key_direction = 1
            end
        }
        use {
            "phaazon/hop.nvim",
            keys = "s",
            config = function()
                local set_keymap = vim.api.nvim_set_keymap
                local opts = {noremap = true, silent = false, expr = false}

                set_keymap("n", "s", "<Nop>", {noremap = false})

                set_keymap("n", "sw", "<cmd>lua require'hop'.hint_words()<cr>", opts)
                set_keymap("x", "sw", "<cmd>lua require'hop'.hint_words()<cr>", opts)
                set_keymap("o", "sw", "<cmd>lua require'hop'.hint_words()<cr>", opts)

                set_keymap("n", "sl", "<cmd>lua require'hop'.hint_lines()<cr>", opts)
                set_keymap("x", "sl", "<cmd>lua require'hop'.hint_lines()<cr>", opts)
                set_keymap("o", "sl", "<cmd>lua require'hop'.hint_lines()<cr>", opts)

                require("hop").setup()
            end
        }
        use {
            "lewis6991/gitsigns.nvim",
            event = "BufReadPre",
            requires = {
                "nvim-lua/plenary.nvim"
            },
            config = function()
                require("gitsigns").setup()
            end
        }
        use {
            "numToStr/Comment.nvim",
            keys = "g",
            config = function()
                require("Comment").setup()
            end
        }
        use {
            "nvim-telescope/telescope.nvim",
            requires = {{"nvim-lua/plenary.nvim"}}
        }
        use {
            "mhartington/formatter.nvim",
            event = "BufWritePre",
            config = function()
                require("_formatter").config()
            end
        }

        -- LSP configurations
        use {
            "williamboman/nvim-lsp-installer"
            -- event = "CmdlineEnter"
        }
        use {
            "neovim/nvim-lspconfig",
            -- event = {"BufRead", "InsertEnter", "CmdlineEnter"},
            event = "BufRead",
            config = function()
                require("_lspconfig")
            end
        }
        use {
            "nvim-treesitter/nvim-treesitter",
            event = "BufRead",
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup {
                    ensure_installed = {
                        "lua",
                        "python",
                        "c",
                        "bash",
                        "javascript",
                        "typescript",
                        "tsx",
                        "html",
                        "css",
                        "json"
                    },
                    highlight = {enable = true, use_languagetree = true},
                    indent = {enable = true}
                }
            end
        }

        -- Snippet and autocompletions
        use {
            "L3MON4D3/LuaSnip",
            -- event = "InsertEnter",
            config = function()
                vim.cmd(
                    [[
                        snoremap <silent> <C-h> <cmd>lua require('luasnip').jump(1)<CR>
                        imap <silent><expr> <C-h> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-h>'
                        snoremap <silent> <C-l> <cmd>lua require('luasnip').jump(-1)<CR>
                        inoremap <silent> <C-l> <cmd>lua require('luasnip').jump(-1)<CR>
                        ]]
                )
            end
        }
        use(
            {
                "hrsh7th/nvim-cmp",
                -- event = "InsertEnter",
                -- after = "LuaSnip",
                -- wants = "LuaSnip",
                requires = {
                    {"rafamadriz/friendly-snippets"},
                    {"onsails/lspkind-nvim"},
                    {"L3MON4D3/LuaSnip"}
                }
            }
        )

        -- Sources for autocompletion
        use({"hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp", after = "nvim-cmp"})
        use({"hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp", after = "nvim-cmp"})
        use({"hrsh7th/cmp-cmdline", requires = "hrsh7th/nvim-cmp", after = "nvim-cmp"})
        use({"hrsh7th/cmp-nvim-lua", requires = "hrsh7th/nvim-cmp", after = "nvim-cmp"})
        use({"saadparwaiz1/cmp_luasnip", requires = "hrsh7th/nvim-cmp", after = "nvim-cmp"})
        use(
            {
                "hrsh7th/cmp-nvim-lsp",
                requires = "hrsh7th/nvim-cmp",
                -- after = "cmp_luasnip",
                config = function()
                    require("_completion").config()
                end
            }
        )
        use(
            {
                "windwp/nvim-autopairs",
                requires = "hrsh7th/nvim-cmp",
                -- after = "nvim-cmp",
                config = function()
                    require("nvim-autopairs").setup {
                        check_ts = true,
                        enable_check_bracket_line = false,
                        disable_filetype = {"TelescopePrompt", "vim"}
                    }

                    -- cmp and autopairs integration
                    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                    local cmp = require("cmp")
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
                end
            }
        )
    end
)

-- Telescope mappings
map("n", "<leader>;", "<cmd>Telescope oldfiles<CR>")
map("n", "<leader>b", "<cmd>Telescope buffers<CR>")
map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
map("n", "<leader>g", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>f", "<cmd>Telescope find_files<CR>")

vim.cmd(
    [[
augroup packer_user_config
autocmd!
autocmd BufWritePost init.lua source <afile> | PackerCompile profile=true
augroup end

set shell=pwsh
set shellcmdflag=-command
set shellquote=\"
set shellxquote=
]]
)

vim.g.did_load_filetypes = 1 -- disable default filetype

if g.neovide == true then
    -- opt("o", "guifont", "Envy Code R,FiraCode NF:h12")
    -- g.neovide_fullscreen = true
    opt("o", "guifont", "Hack NF,FiraCode NF:h18")
    -- opt("o", "guifont", "Fira Code,FiraCode NF:h10")
    -- opt("o", "guifont", "Operator Mono,FiraCode NF:h11")
    -- g.neovide_cursor_vfx_mode = "sonicboom"
    g.neovide_cursor_vfx_mode = "pixiedust"
end

-- Add gitignore and remove packer_compiled from committing
-- packer operations are slow. Create a bug if needed
-- cliboard still consumes more startup time. Find better solution
-- enabling lualine causes increased startuptime in first screen update. Disabled it for now. analyze
-- fix global vim warning for lsp
-- lint warning hide when in insert mode??? nvim bug?
-- Removed InsertEnter event for luasnip and cmp. Bcoz this causes slowness with telescope which have default insert mode. Find way to lazy load
-- move cmp commandline as seperate and lazy load
