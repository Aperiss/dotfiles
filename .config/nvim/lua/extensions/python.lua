if not require("settings").extensions.python then
    return {}
end

-- Python extension: with find_debugpy helper
local function find_debugpy()
    local data_dir = vim.fn.stdpath("data")
    local pkg_path = data_dir .. "/mason/packages/debugpy"

    local python_path = pkg_path .. "/venv/bin/python"
    if vim.fn.filereadable(python_path) == 1 then
        return python_path
    end

    vim.notify("[DAP][Python] debugpy not found at " .. python_path, vim.log.levels.WARN)
    return nil
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "python" })
            return opts
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "debugpy" })
            return opts
        end,
    },

    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.python = { "ruff_format" }
            return opts
        end,
    },


    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.servers = opts.servers or {}
            opts.servers.ruff = {}
            opts.servers.pyright = {
                settings = {
                    python = {
                        analysis = {
                            diagnosticSeverityOverrides = { reportUndefinedVariable = "none" },
                        },
                    },
                    disableOrganizeImports = true,
                    disableTaggedTemplates = true,
                },
            }
            opts.setup = opts.setup or {}
            opts.setup.ruff = function()
                local util = require("util")
                util.on_attach(function(client, bufnr)
                    if client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end
                end)
            end
            opts.setup.pyright = function()
                local util = require("util")
                    util.on_attach(function(client, bufnr)
                        if client.name == "pyright" then
                            local map = function(mode, lhs, rhs, desc)
                                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
                            end
                            map("n", "<leader>lo", "<cmd>PyrightOrganizeImports<cr>", "Organize Imports")
                            map("n", "<leader>lC", function() require("dap-python").test_class() end, "Debug Class")
                            map("n", "<leader>lM", function() require("dap-python").test_method() end, "Debug Method")
                            map("n", "<leader>lE", function() require("dap-python").debug_selection() end, "Debug Selection")
                        end
                    end)
              end
            return opts
        end,
    },

    {
        "mfussenegger/nvim-dap",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap-python" },
        opts = function(_, opts)
            opts.setup = opts.setup or {}
            table.insert(opts.setup, function(dap)
                local dbg_py = find_debugpy()
                if dbg_py then
                    require("dap-python").setup(dbg_py)
                else
                    require("dap-python").setup()
                end
            end)
            return opts
        end,
    },
}
