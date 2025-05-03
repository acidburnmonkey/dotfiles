local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font config
config.font = wezterm.font_with_fallback {
  { family = "Fira Code", weight = "Regular" },
  "Symbols Nerd Font",
}
config.font_size = 12.0
config.line_height = 1.0


config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Window appearance
config.window_background_opacity = 0.92
-- config.enable_tab_bar = true
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


local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = {nil},
    tabline_b = {nil},
    tabline_c = {nil},
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {nil},
    tabline_y = {nil},
    tabline_z = {nil},
  },
  extensions = {},
})




return config
