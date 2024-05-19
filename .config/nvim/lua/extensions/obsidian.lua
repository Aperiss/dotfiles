if not require("settings").extensions.obsidian then
    return {}
end

return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            -- Configure Workspaces Here:
            workspaces = {
                {
                    name = "Personal",
                    path = "~/Vaults/Personal",
                },
                {
                    name = "Pathfinder",
                    path = "~/Vaults/Pathfinder",
                },
            },
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
        end,
    },
}
