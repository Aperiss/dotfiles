if not require("settings").extensions.toml then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "toml" })
        end,
    },
}
