return {
  -- ==========================================
  -- 1. mini.surround 配置
  -- ==========================================
  {
    "nvim-mini/mini.surround",
    version = "*",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  {
    {
      "nvim-mini/mini.ai",
      event = "VeryLazy",
      opts = function()
        local ai = require("mini.ai")
        return {
          custom_textobjects = {
            -- f: 完整的函数定义/函数体 (Function Definition)
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),

            -- c: 完整的类定义 (Class Definition)
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),

            -- F: 函数调用 (Function Call)，例如 requests.get(url)
            F = ai.gen_spec.treesitter({ a = "@call.outer", i = "@call.inner" }, {}),
          },
        }
      end,
    },
  },
}
