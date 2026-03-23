return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          -- 重点 1：必须保持 char mode 开启，否则会失去 ; 和 , 的重复功能
          enabled = true,
          -- 重点 2：取消 Flash 对原生 f, F, t, T 的自动接管
          -- 只让它接管 ; 和 , 即可，剩下的交给我们下面的 keys 重新映射
          keys = { ";", "," },
        },
      },
    },
    keys = {
      -- 禁用默认的 s 和 S
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },

      -- 🚀 释放 s 给 mini.surround 后，将全屏 Jump 绑定到 f
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      -- Treesitter 语法树选择绑定到 F (按需保留，非常好用)
      {
        "F",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },

      -- 🎯 黑科技：将原生的 f 功能绑定到 t
      -- 我们调用 flash 的 char 插件，传入 "f" 来模拟原生 f 的“包含”查找逻辑
      {
        "t",
        mode = { "n", "x", "o" },
        function()
          require("flash.plugins.char").jump("f")
        end,
        desc = "Flash Find (like f)",
      },
      -- 同理，反向查找绑定到 T，模拟 F
      {
        "T",
        mode = { "n", "x", "o" },
        function()
          require("flash.plugins.char").jump("F")
        end,
        desc = "Flash Find Backward (like F)",
      },
    },
  },
}
