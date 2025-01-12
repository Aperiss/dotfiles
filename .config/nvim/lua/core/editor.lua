return {
    -- Nvim Tree
    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("nvim-tree").setup {
                sort = {
                    sorter = "filetype"
                }
            }
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },

        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Recent" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",  desc = "Git Files" },
          { "<leader>fs", "<cmd>Telescope live_grep<cr>",  desc = "Search" },
        },

        opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = function(...)
                            require("telescope.actions").move_selection_next(...)
                        end,
                        ["<C-k>"] = function(...)
                            require("telescope.actions").move_selection_previous(...)
                        end,
                        ["<C-n>"] = function(...)
                            require("telescope.actions").cycle_history_next(...)
                        end,
                        ["<C-p>"] = function(...)
                            require("telescope.actions").cycle_history_prev(...)
                        end,
                    },
                },
            },
        },

        config = function(_, opts)
            local telescope = require "telescope"
            telescope.setup(opts)
            telescope.load_extension "fzf"
        end,
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Which Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            key_labels = { ["<leader>"] = "SPC" },
            mappings = {
                ["q"] = { "<cmd>lua require('util').smart_quit()<CR>", "Quit" },
                ["k"] = { "<cmd>bdelete<cr>", "Kill Buffer" },
                ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
                ["y"] = { "Yank to clipboard" },
                ["Y"] = { "Yank line to clipboard" },
                ["p"] = { "paste from clipboard" },
                f = {
                    name = "+Files",
                    f = { "Find Files" },
                    r = { "Recent Files" },
                    b = { "Find Buffers" },
                    g = { "Git Files" },
                    s = { "Search in Files" },
                },
            },
        },

        config = function(_, opts)
            local whichkey = require "which-key"

            local register_settings = {
                mode = { "n", "v" }, -- NORMAL mode
                prefix = "<leader>",
                buffer = nil,        -- Global mappings. Specify a buffer number for buffer local mappings
                silent = true,       -- use `silent` when creating keymaps
                noremap = true,      -- use `noremap` when creating keymaps
                nowait = true,       -- use `nowait` when creating keymaps
            }

            whichkey.setup(opts)
            whichkey.register(opts.mappings, register_settings)
        end,
    },
}
