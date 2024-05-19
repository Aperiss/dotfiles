return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "nvim-neotest/nvim-nio" },
            { "theHamsta/nvim-dap-virtual-text" },
        },

        keys = {
            { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
            { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
            { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "<leader>dU", function() require("dapui").toggle() end, desc = "Toggle UI", },
            { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
            { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
            { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
            { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
            { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
            { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
            { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
            { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
            { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
            { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
            { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
            { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
        },

        opts = {},
        config = function(plugin, opts)
            require("nvim-dap-virtual-text").setup {
                commented = true,
            }

            local dap, dapui = require "dap", require "dapui"
            dapui.setup {}

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            for k, _ in pairs(opts.setup) do
                opts.setup[k](plugin, opts)
            end
        end,
    },

    {
        "folke/which-key.nvim",
        event = "BufReadPre",
        opts = {
            plugins = { spelling = true },
            mappings = {
                d = {
                    name = "+DAP",
                    C = { "Set Conditional Breakpoint" },
                    E = { "Evaluate Input" },
                    R = { "Run to cursor" },
                    S = { "Scopes" },
                    U = { "Toggle UI" },
                    b = { "Set Back" },
                    c = { "Continue" },
                    d = { "Disconnect" },
                    e = { "Evaluate" },
                    g = { "Get Session" },
                    h = { "Hover Variables" },
                    i = { "Step Into" },
                    o = { "Step Over" },
                    p = { "Pause" },
                    q = { "Quit" },
                    r = { "Toggle REPL" },
                    s = { "Start" },
                    t = { "Toggle Breakpoint" },
                    x = { "Terminate" },
                    u = { "Step Out" },
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
