return {
  -- 1. 禁用 Snacks.explorer 并释放其默认快捷键
  {
    "folke/snacks.nvim",
    opts = {
      -- 核心：关闭 snacks 默认的资源管理器
      explorer = { enabled = false },
    },
    keys = {
      -- 将原本绑定给 snacks.explorer 的按键解绑
      -- 避免由于按键冲突导致不可预期的行为
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },

  -- 2. 深度定制 mini.files 并接管全局快捷键
  {
    "nvim-mini/mini.files",
    opts = {
      options = {
        -- 设为 Neovim 默认的资源管理器（拦截 netrw 和以目录启动时的行为）
        use_as_default_explorer = true,
      },
      windows = {
        -- 开启文件预览窗口（极大提升浏览体验）
        preview = true,
        width_focus = 30,
        width_preview = 50,
      },
      mappings = {
        -- 可以在这里自定义 mini.files 内部的局部快捷键
        close = "q",
        go_in = "l",
        go_in_plus = "<CR>",
        go_out = "h",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
    },
    keys = {
      -- 重新映射大家最熟悉的 <leader>e 和 <leader>E 给 mini.files
      {
        "<leader>e",
        function()
          -- 打开并定位到当前正在编辑的文件所在的目录
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "打开 mini.files (当前文件目录)",
      },
      {
        "<leader>E",
        function()
          -- 打开当前工作区的根目录 (CWD)
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "打开 mini.files (工作区根目录)",
      },
    },
  },
}
