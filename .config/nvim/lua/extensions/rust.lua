if not require("settings").extensions.rust then
    return {}
end

local get_codelldb = require("util").get_codelldb

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust", "toml" })
            return opts
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
            return opts
        end,
    },

    {
        "neovim/nvim-lspconfig",
        ft = "rust",
        opts = function(_, opts)
            opts.servers = opts.servers or {}
            opts.servers.rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        cargo      = { allFeatures = true },
                        checkOnSave = { command = "clippy", extraArgs = { "--no-deps" } },
                    },
                },
                on_attach = function(client, bufnr)
                    if client.name == "rust_analyzer" then
                        vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { buffer = bufnr, desc = "Run CodeLens" })
                    end
                end,
            }
            return opts
        end,
    },

    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        ft = "rust",
        opts = {
            null_ls = { enabled = true, name = "crates.nvim" },
            popup   = { border = "rounded", autofocus = true },
        },
        config = function(_, opts)
            require("crates").setup(opts)
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*/Cargo.toml",
                callback = function(ev)
                    local buf    = ev.buf
                    local crates = require("crates")
                    local map    = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc, silent = true })
                    end
                    map("<leader>lcy", crates.open_repository,         "Open Repository")
                    map("<leader>lcp", crates.show_popup,              "Crates Popup")
                    map("<leader>lci", crates.show_crate_popup,        "Show Info")
                    map("<leader>lcf", crates.show_features_popup,     "Show Features")
                    map("<leader>lcd", crates.show_dependencies_popup, "Show Dependencies")
                    map("<leader>lcv", crates.show_versions_popup,     "Show Versions")
                    map("<leader>lcu", crates.update_crate,            "Crate Update")
                    map("<leader>lcU", crates.upgrade_crate,           "Crate Upgrade")
                end,
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        ft = "rust",
        opts = function(_, opts)
            opts.setup = opts.setup or {}
            table.insert(opts.setup, function(dap)
                -- Rust DAP adapter and configuration
                local adapter, lib = get_codelldb()
                if not adapter then
                    vim.notify("[DAP][Rust] CodeLLDB adapter not found", vim.log.levels.ERROR)
                    return
                end
                dap.adapters.codelldb = {
                    type       = "server",
                    port       = "${port}",
                    executable = {
                        command = adapter,
                        args    = { "--port", "${port}" },
                    },
                }

                local cwd = vim.fn.getcwd()
                dap.configurations.rust = {
                    {
                        name        = "Launch Rust executable",
                        type        = "codelldb",
                        request     = "launch",
                        program     = function()
                            local pkg     = vim.fn.fnamemodify(cwd, ":t")
                            local default = cwd .. "/target/debug/" .. pkg
                            if vim.fn.filereadable(default) == 1 then
                                return default
                            end
                            return vim.fn.input("Path to executable: ", default, "file")
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
