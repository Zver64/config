require("catppuccin").setup({
    custom_highlights = function(colors)
        return {
            LineNr = { fg = colors.text }, -- Example: Set line numbers to Catppuccin's 'text' color
            CursorLineNr = { fg = colors.peach }, -- Example: Set current line number to Catppuccin's 'peach' color
        }
    end,
})

return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
