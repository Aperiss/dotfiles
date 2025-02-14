return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },

        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                completion = { completeopt = "menu,menuone,noinsert" },
                mapping = cmp.mapping.preset.insert {
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-y>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                },

                sources = {
                    { name = "path",                    group_index = 2 },
                    { name = "nvim_lsp",                group_index = 1, keyword_length = 2 },
                    { name = "nvim_lsp_signature_help", group_index = 1 },
                    { name = "buffer",                  group_index = 2, keyword_length = 2 },
                    { name = "luasnip",                 group_index = 1, keyword_length = 2 },
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            }
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },

        build = "make install_jsregexp",
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },

        -- stylua: ignore
        keys = {
            {
                "<C-j>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-j>"
                end,
                expr = true,
                remap = true,
                silent = true,
                mode = "i",
            },
            { "<C-j>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },

        config = function(_, opts)
            require("luasnip").setup(opts)
        end,
    },
}
