-- treesitter-config.lua
local configs = require("nvim-treesitter.configs")
configs.setup {
  -- Add a language of your choice
  ensure_installed = {"cpp", "c", "cmake", "python", "rust", "toml", "go", "lua", "latex"},
  sync_install = false,
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "yaml" } },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
