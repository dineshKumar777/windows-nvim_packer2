local status_ok, formatter = pcall(require, "formatter")
if not status_ok then
    return
end

local M = {}
M.config = function()
    formatter.setup(
        {
            logging = false,
            filetype = {
                lua = {
                    -- luafmt
                    -- npm install --global lua-fmt

                    function()
                        return {
                            exe = "luafmt",
                            args = {"--indent-count", 4, "--stdin"},
                            stdin = true
                        }
                    end
                },
                rust = {
                    -- Rustfmt
                    function()
                        return {
                            exe = "rustfmt",
                            args = {"--emit=stdout"},
                            stdin = true
                        }
                    end
                }
            }
        }
    )
end

vim.api.nvim_exec([[
    augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.lua,*.rs FormatWrite
    augroup END
]], true)

return M

