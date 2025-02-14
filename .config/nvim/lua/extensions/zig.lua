if not require("settings").extensions.zig then
    return {}
end

local function get_codelldb()
    local mason_registry = require "mason-registry"
    local codelldb = mason_registry.get_package("codelldb")
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    return codelldb_path, liblldb_path
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "zig" })
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "zls", "codelldb" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                zls = {},
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        opts = {
            setup = {
                codelldb = function()
                    local codelldb_path, _ = get_codelldb()
                    local dap = require "dap"
                    dap.adapters.codelldb = {
                        type = "server",
                        port = "${port}",
                        executable = {
                            command = codelldb_path,
                            args = { "--port", "${port}" },
                        },
                    }
                    dap.configurations.zig = {
                        {
                            name = "Launch file",
                            type = "codelldb",
                            request = "launch",
                            program = function()
                                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                            end,
                            cwd = "${workspaceFolder}",
                            stopOnEntry = false,
                        },
                    }
                end,
            },
        },
    },
}

