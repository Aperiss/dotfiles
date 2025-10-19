return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "shfmt",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local ensure = function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local pkg = mr.get_package(tool)
                    if not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure)
            else
                ensure()
            end
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            automatic_installation = true,
            ensure_installed = {},
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            { "folke/neodev.nvim", opts = {} },
        },
        opts = {
            servers = {},
            setup = {},
            format = { timeout_ms = 3000 },
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach-group", { clear = true }),
                callback = function(event)
                    local buf = event.buf
                    local map = function(keys, fn, desc)
                        vim.keymap.set('n', keys, fn, { buffer = buf, desc = desc })
                    end

                    map("gd", vim.lsp.buf.definition,          "Goto Definition")
                    map("gr", vim.lsp.buf.references,          "Goto References")
                    map("gI", vim.lsp.buf.implementation,      "Goto Implementation")
                    map("gD", vim.lsp.buf.declaration,         "Goto Declaration")
                    map("K",  vim.lsp.buf.hover,               "Hover Documentation")

                    map("<leader>la", vim.lsp.buf.code_action,    "Code Action")
                    map("<leader>lr", vim.lsp.buf.rename,         "Rename")
                    map("<leader>lf", function()
                        local success, conform = pcall(require, "conform")
                        if success then
                            conform.format({ bufnr = buf, timeout_ms = 3000, lsp_fallback = true })
                        else
                            vim.lsp.buf.format({ timeout_ms = 3000 })
                        end
                    end, "Format")

                    map("<leader>lD", require('telescope.builtin').lsp_type_definitions,    "Goto Type Definition")
                    map("<leader>ls", require('telescope.builtin').lsp_document_symbols,    "Document Symbols")
                    map("<leader>lS", require('telescope.builtin').lsp_dynamic_workspace_symbols, "Workspace Symbols")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = buf,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts.servers[server] or {})
                if opts.setup[server] and opts.setup[server](server, server_opts) then
                    return
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local available = have_mason and mlsp.get_available_servers() or {}
            local to_install = {}
            for server, server_opts in pairs(opts.servers) do
                server_opts = server_opts == true and {} or server_opts
                if server_opts.mason == false or not vim.tbl_contains(available, server) then
                    setup(server)
                else
                    table.insert(to_install, server)
                end
            end

            if have_mason then
                mlsp.setup {
                    ensure_installed = to_install,
                    automatic_installation = false,
                    handlers = { setup },
                }
            end
        end,
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                sh = { "shfmt" },
                bash = { "shfmt" },
            },
            default_format_opts = {
                timeout_ms = 3000,
                async = false,
                quiet = false,
            },
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2" },
                },
            },
        },
    },
}
