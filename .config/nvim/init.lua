require "settings.options"
require "settings.lazy"

if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_autocmd("Neovim", { clear = true }),
        pattern = "VeryLazy",
        callback = function()
            require "settings.autocmds"
            require "settings.keymaps"
        end,
    })
else
    require "settings.autocmds"
    require "settings.keymaps"
end
