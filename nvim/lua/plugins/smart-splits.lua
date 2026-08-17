return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    -- Явно включаем интеграцию, чтобы плагин знал, куда "выпрыгивать"
    multiplexer_integration = "tmux",
  },
  keys = {
    -- Настраиваем Ctrl + hjkl через функции плагина
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move left" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move down" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move up" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move right" },
  },
}
