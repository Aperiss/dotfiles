-- See ':help vim.highlight.on_yank()'
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", {
    clear = true
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- Toggle functions
function _G.toggle_whitespace()
    if vim.opt.list:get() then
        vim.opt.list = false
        print("Whitespace visualization: OFF")
    else
        vim.opt.list = true
        vim.opt.listchars = {
            space = '·',
            tab = '→ ',
            trail = '•',
            extends = '▶',
            precedes = '◀',
            nbsp = '␣'
        }
        print("Whitespace visualization: ON")
    end
end

function _G.toggle_line_numbers()
    if vim.opt.relativenumber:get() then
        vim.opt.relativenumber = false
        vim.opt.number = true  -- Ensure absolute numbers are shown
        print("Line numbers: ABSOLUTE")
    else
        vim.opt.relativenumber = true
        vim.opt.number = true  -- Keep absolute numbers on with relative
        print("Line numbers: RELATIVE")
    end
end
