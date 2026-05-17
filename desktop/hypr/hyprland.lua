require("mods.init")
require("mods.workspaces")
require("mods.keybinds")
require("mods.windows")

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "DP-1",
	mode = "3840x2160@144",
	position = "0x0",
	scale = 2,
})

hl.monitor({
	output = "DP-2",
	mode = "3840x2160@60",
	position = "-1920x-950",
	scale = 2,
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- XWayland scaling
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- Input
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape,compose:rctrl",
		kb_rules = "",

		follow_mouse = 1,
		force_no_accel = false,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- General
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,
		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",
		allow_tearing = false,
	},
})

-- Decoration
hl.config({
	decoration = {
		rounding = 10,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
		},

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},
})

-- Layer rule (waybar blur)
hl.layer_rule({
	name = "waybar-blur",
	match = { namespace = "waybar" },
	blur = true,
})

-- Animations
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- Dwindle layout
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- Master layout
hl.config({
	master = {},
})

-- Misc
hl.config({
	misc = {
		disable_splash_rendering = true,
		disable_hyprland_logo = true,
	},
})

-- Per-device config
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
