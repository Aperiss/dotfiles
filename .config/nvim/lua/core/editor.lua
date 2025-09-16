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
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            -- Always show one global statusline
            vim.opt.laststatus = 3
            -- Optional: Hide built-in "-- INSERT --" since Lualine shows mode
            vim.opt.showmode = false

            require('lualine').setup {
                options = {
                    icons_enabled        = true,
                    theme                = 'auto',         -- pick up your colorscheme
                    component_separators = { '|', '|' },
                    section_separators   = { '',  '' },
                    globalstatus         = true,           -- span full width
                    disabled_filetypes   = {},             -- enable everywhere
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                },
                extensions = {},
            }
        end,
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
                { "<leader>t", group = "+TextFormat", mode = { "n", "v" } },
                {"<leader>tw", "<cmd>set wrap!<CR>", desc = "Toggle text wrap", mode = { "n", "v" } },
                {"<leader>ts", "<cmd>lua toggle_whitespace()<CR>", desc = "Toggle whitespace", mode = { "n", "v" } },
                {"<leader>tn", "<cmd>lua toggle_line_numbers()<CR>", desc = "Toggle line numbers", mode = { "n", "v" } },
            })
        end,
    },
}
