local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "g,", "g,zvzz", opts)
keymap("n", "g;", "g;zvzz", opts)

keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "Q", "<nop>", opts)

keymap("v", "<leader>y", [["+y]], opts)
keymap("n", "<leader>y", [["+y]], opts)
keymap("n", "<leader>Y", [["+Y]], opts)

keymap("v", "d", [["_d]], opts)
keymap("n", "d", [["_d]], opts)
keymap("v", "x", "d", opts)

keymap("v", "p", '"_dP', opts)
keymap("n", "<leader>p", '"+p', opts)

keymap("n", "]<Space>", "O<Esc>", opts)
keymap("n", "[<Space>", "o<Esc>", opts)

keymap("n", "<S-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<S-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>", opts)
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>", opts)
