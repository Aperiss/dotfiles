-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.nvim_workspace()
local rust_lsp = lsp.build_options('rust_analyzer', {})

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

