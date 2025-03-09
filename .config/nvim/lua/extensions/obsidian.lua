if not require("settings").extensions.obsidian then
    return {}
end

return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Vaults/Personal",
                },
                {
                    name = "ttrpg",
                    path = "~/Vaults/TTRPG",
                },
                {
                    name = "work",
                    path = "~/Vaults/Work",
                },
            },
        },
    },
    {
        "oflisback/obsidian-bridge.nvim",
        opts = {
            obsidian_server_address = "https://127.0.0.1:27124",
            cert_path = "~/.ssl/obsidian.crt",

        },
        event = {
            "BufReadPre *.md",
           "BufNewFile *.md",
        },
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
