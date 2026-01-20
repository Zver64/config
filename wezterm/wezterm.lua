local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 16
config.color_scheme = "Catppuccin Mocha"
config.scrollback_lines = 50000

config.keys = {
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
	{
		key = "UpArrow",
		mods = "CMD",
		action = wezterm.action.ScrollToTop,
	},
	{
		key = "DownArrow",
		mods = "CMD",
		action = wezterm.action.ScrollToBottom,
	},
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
}

-- Create a copy of the default search_mode key table.
-- Using `wezterm.gui.default_key_tables().search_mode` can sometimes return `nil`
-- if not all WezTerm components are fully initialized yet.
-- This ensures a valid table to work with.
local search_mode = wezterm.gui.default_key_tables().search_mode or {}
local copy_mode = wezterm.gui.default_key_tables().copy_mode or {}

table.insert(search_mode, { key = "[", mods = "CTRL", action = wezterm.action.CopyMode("Close") })
table.insert(copy_mode, { key = "[", mods = "CTRL", action = wezterm.action.CopyMode("Close") })
table.insert(search_mode, { key = 'Enter', mods = 'NONE', action = wezterm.action.CopyMode('AcceptPattern') })


-- Assign the modified key table to the configuration.
config.key_tables = {
	search_mode = search_mode,
  copy_mode = copy_mode,
}

return config
