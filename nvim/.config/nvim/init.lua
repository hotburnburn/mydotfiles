-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.lsp.enable("ruff")

vim.opt.clipboard = "unnamedplus"
