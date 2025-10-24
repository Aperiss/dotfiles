if not require("settings").extensions.zig then
  return {}
end

local get_codelldb = require("util").get_codelldb

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "zig" })
            return opts
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "zls", "codelldb" })
            return opts
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.zig = { "zig" }
            opts.formatters = opts.formatters or {}
            opts.formatters.zig = {
                command = "zig",
                args = { "fmt", "--stdin" },
                stdin = true,
            }
            return opts
        end,
    },

    {
        "neovim/nvim-lspconfig", opts = function(_, opts)
            opts.servers = opts.servers or {}
            opts.servers.zls = {}
        return opts
        end,
    },

    {
        "mfussenegger/nvim-dap",
        ft = "zig",
        opts = function(_, opts)
            opts.setup = opts.setup or {}
            table.insert(opts.setup, function(dap)
                -- Zig DAP adapter and configuration
                local adapter, lib = get_codelldb()
                if not adapter then
                    vim.notify("[DAP][Zig] CodeLLDB adapter not found", vim.log.levels.ERROR)
                    return
                end

                dap.adapters.codelldb = {
                    type       = "server",
                    port       = "${port}",
                    executable = { command = adapter, args = { "--port", "${port}" } },
                }

                local cwd = vim.fn.getcwd()
                dap.configurations.zig = {
                    {
                        name        = "Launch Zig Executable",
                        type        = "codelldb",
                        request     = "launch",
                        program     = function()
                            return vim.fn.input("Path to Zig executable: ", cwd .. "/", "file")
                        end,
                        cwd         = cwd,
                        stopOnEntry = false,
                    },
                }
            end)
            return opts
        end,
    },
}
