---@module 'lazy'
---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,

    daily_notes = {
      enabled = true,
      folder = "daily notes",
      date_format = "YYYY/MM/YYYY-MM-DD",
    },
    workspaces = {
      {
        name = "work",
        path = "~/Documents/Obsidian",
      },
    },
  },
}
