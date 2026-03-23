return {
  -- 1. 告诉 LazyVim 里的 lspconfig 忽略 ruff 的 mason 安装
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          mason = false, -- 关键属性：这是 LazyVim 专属设定，告诉它不要通过 mason 安装此 LSP
        },
      },
    },
  },

  -- 2. 从 mason 的工具列表( formatter / linter )中剔除 ruff
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- 过滤掉 ensure_installed 列表里的 ruff 和 ruff-lsp
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = vim.tbl_filter(function(name)
          return name ~= "ruff" and name ~= "ruff-lsp"
        end, opts.ensure_installed)
      end
    end,
  },
}
