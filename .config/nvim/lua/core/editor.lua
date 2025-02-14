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
            local whichkey = require("which-key")
            whichkey.add({
                { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree", mode = { "n", "v" } },
            })
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

            pickers = {
                find_files = {
                    file_ignore_patterns = { ".git", ".venv" },
                    hidden = true
                },
                live_grep = {
                    file_ignore_patterns = { ".git", ".venv" },
                    additional_args = {'--hidden'}
                }
            },
            extensions = {
                "fzf"
            }
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
        opts = {
            preset = "modern",
            replace = { ["<leader>"] = "SPC" },
        },

        config = function(_, opts)
            local whichkey = require "which-key"
            whichkey.setup(opts)
            whichkey.add({
                { "<leader>q", "<cmd>lua require('util').smart_quit()<CR>", desc = "Smart Quit", mode = { "n", "v" } },
                { "<leader>k", "<cmd>bdelete<cr>", desc = "Kill Buffer", mode = { "n", "v" } },
                { "<leader>y", desc = "Yank to clipboard", mode = { "n", "v" } },
                { "<leader>Y", desc = "Yank line to clipboard", mode = { "n", "v" } },
                { "<leader>p", desc = "Paste from clipboard", mode = { "n", "v" } },
                { "<leader>f", group = "+Files", mode = { "n", "v" } },
                { "<leader>d", group = "+DAP", mode = { "n", "v" } },
                { "<leader>l", group = "+LSP", mode = { "n", "v" } },
                { "<leader>x", group = "+Error", mode = { "n", "v" } },
            })
        end,
    },
}
