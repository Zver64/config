return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = { enable = false },
    workspaces = {
      {
        name = "work",
        path = "~/Documents/Obsidian",
      },
    },
  },
}
