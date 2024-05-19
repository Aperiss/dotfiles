return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    event = "BufReadPost",

    opts = {
        sync_install = false,
        ensure_installed = {
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            additional_vim_regex_highlighting = { "markdown" },
        },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental ="<c-s>",
                node_decremental = "<A-space>",
            },
        },
        matchup = {
            enable = true,
        },
    },

    config = function(_, opts)
        if type(opts.ensure_installed) == "table" then
            --@type table<string, boolean>
            local added = {}
            opts.ensure_installed = vim.tbl_filter(function(lang)
                if added[lang] then
                    return false
                end
                added[lang] = true
                return true
            end, opts.ensure_installed)
        end
        require("nvim-treesitter.configs").setup(opts)
    end,
}
