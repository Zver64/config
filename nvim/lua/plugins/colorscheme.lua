return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.text },
          CursorLineNr = { fg = colors.peach },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
