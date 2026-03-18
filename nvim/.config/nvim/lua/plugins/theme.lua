return {
  -- 1. 引入 catppuccin 插件
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 优先级设为最高，确保在其他 UI 插件前加载
    opts = {
      flavour = "mocha", -- 推荐 mocha 模式，最经典的深色猫猫派
      -- 这里还可以加很多针对其他插件的透明度、高亮微调

      custom_highlights = function(colors)
        -- 我们自定义一个暗紫色作为聚焦背景，比纯 base 亮一点，带有 Mocha mauve 的色调
        local focus_bg = "#2c2638"

        return {
          -- ✨ 1. 当前聚焦的面板 (Active)
          MiniFilesTitleFocused = { fg = colors.mauve, bg = focus_bg, style = { "bold" } }, -- 紫色标题
        }
      end,
    },
  },

  -- 2. 告诉 LazyVim 将其设为全局默认主题，覆盖掉 tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
