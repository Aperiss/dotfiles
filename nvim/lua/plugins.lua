return {
    -- Which-key
    {
        "folke/which-key.nvim",
        lazy = true,
    },

    -- Trouble NVIM
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Vim-Tmux Navigator
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Leap (Better Navigation)
    {
        "ggandor/leap.nvim",
        dependencies = {
            "tpope/vim-repeat"
        },
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs"
    },

    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    -- Nvimtree
    {
        'nvim-tree/nvim-tree.lua',
        lazy = true,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        }
    },

    -- Harpoon 
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },

    -- Telescope (Fuzzy Finder)
    {
        'nvim-telescope/telescope.nvim',
        lazy = true,
        dependencies = {
            {'nvim-lua/plenary.nvim'},
        }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
    },

    -- Undotree
    {
        "jiaoshijie/undotree",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },

    -- Language Support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'simrat39/rust-tools.nvim'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    },

    -- Copilot
    {
        'zbirenbaum/copilot.lua',
    },
    {
        'AndreM222/copilot-lualine',
    },
    {
        'zbirenbaum/copilot-cmp',
    },
}
