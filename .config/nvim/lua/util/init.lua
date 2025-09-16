local M = {}

function M.smart_quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_windows = vim.call("win_findbuf", bufnr)
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if modified then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
            if input == "y" then
                vim.cmd "qa!"
            end
        end)
    else
        vim.cmd "qa!"
    end
end

function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, bufnr)
        end,
    })
end

function M.get_codelldb()
    local adapter_path = vim.fn.exepath("codelldb")
    if adapter_path == "" then
        vim.notify(
            "[DAP] 'codelldb' not found in PATH; run :MasonInstall codelldb",
            vim.log.levels.ERROR
        )
    return nil, nil
    end

    local mason_root = vim.fn.expand("$MASON")
    if mason_root == "" then
        vim.notify(
            "[DAP] $MASON not set; ensure you're using mason.nvim v2+",
            vim.log.levels.ERROR
        )
        return adapter_path, nil
    end

    local lib_dir = table.concat({
        mason_root,
        "packages",
        "codelldb",
        "extension",
        "lldb",
        "lib",
    }, "/")

    local candidates = vim.fn.globpath(lib_dir, "liblldb*.dylib", false, true)
    local liblldb_path = candidates[1] or ""

    if liblldb_path == "" then
        vim.notify(
            string.format("[DAP] liblldb not found in %s", lib_dir),
            vim.log.levels.ERROR
        )
        return adapter_path, nil
    end

    return adapter_path, liblldb_path
end

return M
