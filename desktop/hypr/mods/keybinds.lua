---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local terminal = "wezterm"
local fileManager = "nemo"
local menu = "~/.config/rofi/rofimenu/launcher.sh"
local apps = "~/.config/rofi/apps/apps.sh"
local powermenu = "~/.config/rofi/rofipowermenu/powermenu.sh"
local screenshot = 'grim -g "$(slurp)" ' .. os.getenv("HOME") .. "/screenshots/$(date +'%Y-%m-%d-%H%M%S').png"
local monitorConstrain = require("mods/mouseConstrain")

-- App launchers
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(apps))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + G", monitorConstrain)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/quickshell/network/network_toggle.sh"))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + ALT + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh mute"), { locked = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh vup"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh vdown"),
	{ locked = true, repeating = true }
)
hl.bind("Print", hl.dsp.exec_cmd(screenshot .. ' && dunstify "Screenshot Saved"'))

-- Move focus with arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
