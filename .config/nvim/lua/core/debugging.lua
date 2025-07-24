return {
    {
        "williamboman/mason.nvim",
        opts = { ensure_installed = {} },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure()
                for _, tool in ipairs(opts.ensure_installed) do
                    local pkg = mr.get_package(tool)
                    if not pkg:is_installed() then pkg:install() end
                end
            end
            if mr.refresh then mr.refresh(ensure) else ensure() end
        end,
    },

    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>dc", function() require("dap").continue()      end, desc = "DAP Continue" },
            { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
            { "<leader>di", function() require("dap").step_into()      end, desc = "DAP Step Into" },
            { "<leader>do", function() require("dap").step_over()      end, desc = "DAP Step Over" },
            { "<leader>du", function() require("dap").step_out()       end, desc = "DAP Step Out" },
            { "<leader>dU", function() require("dapui").toggle()      end, desc = "DAP UI Toggle" },
            { "<leader>dr", function() require("dap").repl.toggle()    end, desc = "DAP REPL Toggle" },
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
            local dap   = require("dap")
            local dapui = require("dapui")
            local vt    = require("nvim-dap-virtual-text")
            dapui.setup()
            vt.setup { commented = true }
            for _, fn in ipairs(opts.setup) do
                if type(fn) == "function" then fn(dap) end
            end
        end,
    },
}
