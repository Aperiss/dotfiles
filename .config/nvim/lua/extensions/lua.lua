if not require("settings").extensions.lua then
    return {}
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "lua", "luadoc", "luap" })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "stylua" })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require "null-ls"
            table.insert(opts.sources, nls.builtins.formatting.stylua)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                            telemetry = { enable = false },
                            hint = {
                                enable = false,
                            },
                        },
                    },
                },
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "jbyuki/one-small-step-for-vimkind" },
        },
        opts = {
            setup = {
                osv = function(_, _)
                    local dap = require "dap"
                    dap.configurations.lua = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance",
                            host = function()
                                local value = vim.fn.input "Host [127.0.0.1]: "
                                if value ~= "" then
                                    return value
                                end
                                return "127.0.0.1"
                            end,
                            port = function()
                                local val = tonumber(vim.fn.input("Port: ", "8086"))
                                assert(val, "Please provide a port number")
                                return val
                            end,
                        },
                    }

                    dap.adapters.nlua = function(callback, config)
                        callback { type = "server", host = config.host, port = config.port }
                    end
                end,
            },
        },
    },
}
