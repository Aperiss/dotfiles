return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>ds", function() require("dap").continue() end, desc = "DAP Start" },
            { "<leader>dc", function() require("dap").continue() end, desc = "DAP Continue" },
            { "<leader>dS", function() require("dap").terminate() end, desc = "DAP Stop" },
            { "<leader>dR", function() require("dap").restart() end, desc = "DAP Restart" },
            { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
            { "<leader>dT", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "DAP Conditional Breakpoint" },
            { "<leader>di", function() require("dap").step_into() end, desc = "DAP Step Into" },
            { "<leader>do", function() require("dap").step_over() end, desc = "DAP Step Over" },
            { "<leader>du", function() require("dap").step_out() end, desc = "DAP Step Out" },
            { "<leader>dU", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP REPL Toggle" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "DAP Run Last" },
            { "<leader>de", function() require("dapui").eval() end, desc = "DAP Eval", mode = {"n", "v"} },
        },

        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },

        opts = {
            setup = {},
        },

        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            local vt = require("nvim-dap-virtual-text")

            -- Setup DAP UI with better layout
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = { "repl", "console" },
                        size = 10,
                        position = "bottom",
                    },
                },
            })

            -- Setup virtual text
            vt.setup({ commented = true })

            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Better breakpoint signs
            vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' })
            vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DapBreakpoint' })
            vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DapBreakpoint' })
            vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped' })
            vim.fn.sign_define('DapLogPoint', { text = '◉', texthl = 'DapLogPoint' })

            -- Run language-specific setup functions
            for _, fn in ipairs(opts.setup) do
                if type(fn) == "function" then fn(dap) end
            end
        end,
    },
}
