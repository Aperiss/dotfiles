-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require('copilot').setup({
    suggestion = {enabled = false},
    panel = {enabled = false},
})

require('copilot_cmp').setup()

local cmp = require('cmp')

cmp.setup({
    sources = {
        {name = 'copilot'},
        {name = 'nvim_lsp'},
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        })
    })
})

