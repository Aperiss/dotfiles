if not require("settings").extensions.markdown then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "marksman" })
        end,
    },
}
