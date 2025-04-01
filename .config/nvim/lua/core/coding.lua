return {
    -- Numb (Better number line command navigation)
    {
        "nacro90/numb.nvim",
        event = "BufReadPre",
        config = true,
    },

    -- Vim-Tmux Navigator
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Indentation Lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPre",
        config = function()
            require("ibl").setup({
                scope = {
                    show_start = false,
                    show_end = false,
                },
            })
        end,
    },

    -- Surround
    {
        "echasnovski/mini.surround",
        optional = true,
        opts = {
            mappings = {
                add = "gza",
                delete = "gzd",
                find = "gzf",
                find_left = "gzF",
                highlight = "gzh",
                replace = "gzr",
                update_n_lines = "gzn",
            },
        },
    },

    -- Better Commenting
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        keys = {
            { "gc", mode = { "n", "v" } },
            { "gcc", mode = { "n", "v" } },
            { "gbc", mode = { "n", "v" } }
        },
        config = function(_, _)
            local opts = {
                ignore = "^$",
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
            require("Comment").setup(opts)
        end,
    },

    -- Leap (Faster navigation)
    {
        "ggandor/leap.nvim",
        enabled = true,
        keys = {
            { "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
            { "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
        },
        config = function(_, opts)
            local leap = require("leap")
                for k, v in pairs(opts) do
                  leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },
}
