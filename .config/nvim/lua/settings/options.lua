local option = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

option.guicursor = ""

option.nu = true
option.relativenumber = false
option.mouse = 'a'

option.tabstop = 4
option.softtabstop = 4
option.shiftwidth = 4
option.expandtab = true

option.smartindent = true

option.wrap = false
option.linebreak = true

option.swapfile = false
option.backup = false
option.undodir = os.getenv("HOME") .. "/.vim/undodir"
option.undofile = true

option.hlsearch = false
option.incsearch = true

option.termguicolors = true

option.scrolloff = 10
option.sidescrolloff = 10

option.updatetime = 200
option.colorcolumn = "101"

option.foldenable = false
option.completeopt = { 'menuone', 'noselect', 'noinsert' }
option.shortmess = option.shortmess + { c = true }
option.conceallevel = 1
-- vim.api.nvim_set_option('updatetime', 300)

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
