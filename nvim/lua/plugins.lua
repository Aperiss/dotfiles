return {
    -- Which-key
    {
        "folke/which-key.nvim",
        lazy = true,
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
    },

    -- Vim-Tmux Navigator
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
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

    ---- Better Indentation
    ---- Indentation Highlights
    --{
    --    "lukas-reineke/indent-blankline.nvim",
    --},
    ---- Rainbow Highlights
    --{
    --    "HiPhish/nvim-ts-rainbow2",
    --},

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
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    },
}
