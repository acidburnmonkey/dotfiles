local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font config
config.font = wezterm.font_with_fallback {
  { family = "Fira Code", weight = "Regular" },
  "Symbols Nerd Font",
}
config.font_size = 12.0
config.line_height = 1.0


-- Window appearance
config.window_background_opacity = 0.92
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 600

-- Bell
config.audible_bell = "Disabled"

-- Key bindings
config.keys = {
    { key = "C", mods = "CTRL|SHIFT", action = wezterm.action.SendKey { key = "c", mods = "CTRL" } },
    { key = "c", mods = "CTRL", action = wezterm.action.CopyTo "Clipboard" },
    { key = "v", mods = "CTRL", action = wezterm.action.PasteFrom "Clipboard" },
    { key = "U", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
    { key = "LeftArrow", mods = "CTRL", action = wezterm.action.ActivateTabRelative(-1) },
    { key = "RightArrow", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
    { key = "t", mods = "ALT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
    { key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane { confirm = false } },
}

-- Theme
config.color_scheme = "Catppuccin Mocha"

return config
