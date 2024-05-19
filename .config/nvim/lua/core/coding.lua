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
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        --      Old text                    Command         New text
        -- --------------------------------------------------------------------------------
        --     surr*ound_words             ysiw)           (surround_words)
        --     *make strings               ys$"            "make strings"
        --     [delete ar*ound me!]        ds]             delete around me!
        --     remove <b>HTML t*ags</b>    dst             remove HTML tags
        --     'change quot*es'            cs'"            "change quotes"
        --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        --     delete(functi*on calls)     dsf             function calls
        config = function()
            require("nvim-surround").setup()
        end
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
}
