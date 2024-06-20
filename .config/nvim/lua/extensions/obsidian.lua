if not require("settings").extensions.obsidian then
    return {}
end

return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = false,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            -- Configure Workspaces Here:
            workspaces = {
                {
                    name = "Personal",
                    path = "~/Vaults/Personal",
                },
                {
                    name = "Work",
                    path = "~/Vaults/Work",
                },
            },

            mappings = {
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                ["<leader>ch"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },
            },

            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },

            daily_notes = {
                folder = "50_inbox/51_daily",
            },
            new_notes_location = "current_dir",

            -- Optional, customize how note file names are generated given the ID, target directory, and title.
            ---@param spec { id: string, dir: obsidian.Path, title: string|? }
            ---@return string|obsidian.Path The full path to the new note.
            note_path_func = function(spec)
                -- This is equivalent to the default behavior.
                local path = spec.dir / tostring(spec.id)
                return path:with_suffix(".md")
            end,

            ---@param title string|?
            ---@return string
            note_id_func = function(title)
                local body = ""
                if title ~= nil then
                    body = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    for _ = 1, 4 do
                        body = body .. string.char(math.random(65, 90))
                    end
                end
                return body .. "(" .. tostring(os.time()) .. ")"
            end,

            picker = {
                name = "telescope.nvim",
                mappings = {
                    new = "<C-x>",
                    insert_link = "<C-l>",
                }
            },

            attachments = {
                img_folder = "_META/_Assets",
                ---@param client obsidian.Client
                ---@param path obsidian.Path the absolute path to the image file
                ---@return string
                img_text_func = function(client, path)
                    path = client:vault_relative_path(path) or path
                    return string.format("![%s](%s)", path.name, path)
                end,
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
        end,
    },
}
