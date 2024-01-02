-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero').preset({})

lsp.on_attach = function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end

lsp.skip_server_setup({'rust_analyzer'})
lsp.setup()

local rust_tools = require('rust-tools')

rust_tools.setup({
    server = {
        on_attach = function(_, bufnr)
            vim.keymap.set('n', '<C-space>', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
            vim.keymap.set('n', '<Leader>a', rust_tools.code_action_group.code_action_group, {buffer = bufnr})
        end,
    },
})

require('copilot').setup({
    suggestion = {enabled = false},
    panel = {enabled = false},
})

require('copilot_cmp').setup()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    }),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
    sources = {
        {name = 'path'},
        {name = 'copilot'},
        {name = 'nvim_lsp', keyword_length = 2},
        {name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
        {name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
        {name = 'buffer', keyword_length = 2 },        -- source current buffer
        {name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
        {name = 'calc'},                               -- source for math calculation
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    -- Enable LSP snippets
    snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
    },
    mapping = cmp_mappings
})
