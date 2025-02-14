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
            local mr = require "mason-registry"
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
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
            format = {
                timeout_ms = 3000,
            },
        },

        config = function(_, opts)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach-group', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
                    end

                    map("gd", require('telescope.builtin').lsp_definitions, 'Goto Definition')
                    map("gr", require('telescope.builtin').lsp_references, 'Goto References')
                    map("gI", require('telescope.builtin').lsp_implementations, 'Goto Implementation')
                    map("gD", vim.lsp.buf.declaration, 'Goto Declaration')
                    map("K", vim.lsp.buf.hover, 'Hover Documentation')

                    map("<leader>la", vim.lsp.buf.code_action, 'Code Action')
                    map("<leader>lD", require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition')
                    map("<leader>ls", require("telescope.builtin").lsp_document_symbols, 'Document Symbols')
                    map("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, 'Workspace Symbols')
                    map("<leader>lr", vim.lsp.buf.rename, 'Rename')

                    map("<leader>xx", function() require("trouble").toggle() end, 'Toggle Diagnostics')
                    map("<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, 'Workspace Diagnostics')
                    map("<leader>xd", function() require("trouble").toggle("document_diagnostics") end, 'Document Diagnostics')
                    map("<leader>xq", function() require("trouble").toggle("quickfix") end, 'Quick Fix')
                    map("<leader>xl", function() require("trouble").toggle("loclist") end, 'Loclist')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            local servers = opts.servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mlsp_servers = {}
            if have_mason then
                all_mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {}
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup { ensure_installed = ensure_installed }
                mlsp.setup_handlers { setup }
            end
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        event = "BufReadPre",
        dependencies = { "mason.nvim" },
        opts = function()
            local nls = require "null-ls"
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    nls.builtins.formatting.shfmt,
                },
            }
        end,
    },
}
