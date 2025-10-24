if not require("settings").extensions.golang then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "go", "gomod" })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "delve", "golangci-lint", "gofumpt", "goimports", "golangci-lint-langserver", "impl", "gomodifytags", "iferr", "gotestsum"})
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.go = { "gofumpt", "goimports" }
            return opts
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            staticcheck = true,
                            semanticTokens = true,
                        },
                    },
                },
                golangci_lint_ls = {},
            },
            setup = {
                gopls = function(_, _)
                    local lsp_utils = require "util"
                    lsp_utils.on_attach(function(client, bufnr)
                        local map = function(mode, lhs, rhs, desc)
                            if desc then
                                desc = desc
                            end
                            vim.keymap.set(
                                mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
                        end

                        --stylua: ignore
                        if client.name == "gopls" then
                            map("n", "<leader>lT", "<cmd>lua require('dap-go').debug_test()<cr>", "Go Debug Test" )
                        end
                    end)
                end,
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            opts = {}
        },
    },
}

