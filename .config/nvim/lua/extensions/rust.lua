if not require("settings").extensions.rust then
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
            vim.list_extend(opts.ensure_installed, { "rust", "toml" })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "codelldb" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            checkOnSave = {
                                command = "cargo clippy",
                                extraArgs = { "--no-deps" },
                            },
                        },
                    },
                },
            },
            setup = {
                rust_analyzer = function(_, opts)
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
                        if client.name == "rust_analyzer" then
                            map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens")
                        end
                    end)

                    vim.api.nvim_create_autocmd({ "BufEnter" }, {
                        pattern = { "Cargo.toml" },
                        callback = function(event)
                            local bufnr = event.buf

                            local map = function(mode, lhs, rhs, desc)
                                if desc then
                                    desc = desc
                                end
                                vim.keymap.set(
                                    mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
                            end
                            map("n", "<leader>lcy", "<cmd> lua require'crates'.open_repository()<cr>", "Open Repository")
                            map("n", "<leader>lcp", "<cmd> lua require'crates'.show_popup()<cr>", "Show Popup")
                            map("n", "<leader>lci", "<cmd> lua require'crates'.show_crate_popup()<cr>", "Show Info")
                            map("n", "<leader>lcf", "<cmd> lua require'crates'.show_features_popup()<cr>", "Show Features")
                            map("n", "<leader>lcd", "<cmd> lua require'crates'.show_dependencies_popup()<cr>", "Show Dependencies")
                            map("n", "<leader>lcv", "<cmd> lua require'crates'.show_versions_popup()<cr>", "Show Versions")
                            map("n", "<leader>lcu", "<cmd> lua require'crates'.update_crate()<cr>", "Update Crate")
                            map("n", "<leader>lcU", "<cmd> lua require'crates'.upgrade_crate()<cr>", "Upgrade Crate")
                        end,
                    })

                end,
            },
        },
    },

    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
            popup = {
                border = "rounded",
                autofocus = true,
            },
        },
        config = function(_, opts)
            require("crates").setup(opts)
        end,
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
                    dap.configurations.cpp = {
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
                    dap.configurations.c = dap.configurations.cpp
                    dap.configurations.rust = dap.configurations.cpp
                end,
            },
        },
    },

    {
        "folke/which-key.nvim",
        event = "BufReadPre",
        opts = {
            plugins = { spelling = true },
            mappings = {
                lc = {
                    name = "+Crates",
                    p = { "Show Popup" },
                },
            },
        },

        config = function(_, opts)
            local whichkey = require "which-key"

            local register_settings = {
                mode = { "n", "v" }, -- NORMAL mode
                prefix = "<leader>",
                buffer = nil,        -- Global mappings. Specify a buffer number for buffer local mappings
                silent = true,       -- use `silent` when creating keymaps
                noremap = true,      -- use `noremap` when creating keymaps
                nowait = true,       -- use `nowait` when creating keymaps
            }
            whichkey.setup(opts)
            whichkey.register(opts.mappings, register_settings)
        end,
    },
}

