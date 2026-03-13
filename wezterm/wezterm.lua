local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local config = wezterm.config_builder()

function merge_tables(t1, t2)
	for _, val in ipairs(t2) do
		table.insert(t1, val)
	end
	return t1
end

-- leader like in tmux
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.font = wezterm.font("FiraMono Nerd Font")
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
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "|",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Вертикальный сплит (Leader + v)
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Горизонтальный сплит (Leader + h)
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
}

-- Create a copy of the default search_mode key table.
-- Using `wezterm.gui.default_key_tables().search_mode` can sometimes return `nil`
-- if not all WezTerm components are fully initialized yet.
-- This ensures a valid table to work with.
local search_mode = wezterm.gui.default_key_tables().search_mode or {}
local copy_mode = wezterm.gui.default_key_tables().copy_mode or {}
local common_mode = {
	key = "[",
	mods = "CTRL",
	action = wezterm.action.CopyMode("Close"),
}

table.insert(search_mode, common_mode)
table.insert(copy_mode, common_mode)
-- table.insert(search_mode, { key = "Enter", mods = "NONE", action = wezterm.action.CopyMode("AcceptPattern") })

-- Assign the modified key table to the configuration.
config.key_tables = {
	search_mode = search_mode,
	copy_mode = copy_mode,
}

smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

return config
