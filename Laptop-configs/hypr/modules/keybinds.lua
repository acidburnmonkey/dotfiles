---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "wezterm"
local fileManager = "nemo"
local menu        = "~/.config/rofi/rofimenu/launcher.sh"
local apps        = "~/.config/rofi/apps/apps.sh"
local powermenu   = "~/.config/rofi/rofipowermenu/powermenu.sh"
local screenshot  = "grim -g \"$(slurp)\" $HOME/screenshots/$(date +'%Y-%m-%d-%H%M%S').png"

local mainMod = "SUPER"

---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu .. ' & sleep 0.2; hyprctl dispatch focuswindow "^(Rofi)"'))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(apps .. ' & sleep 0.2; hyprctl dispatch focuswindow "^(Rofi)"'))
hl.bind("CONTROL + ALT + L", hl.dsp.exec_cmd(powermenu .. ' & sleep 0.2; hyprctl dispatch focuswindow "^(Rofi)"'))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.config/quickshell/network/network_toggle.sh"))

-- Media keys
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh mute"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh vup"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh vdown"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh bup"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/dunstthree/dunstthree.sh bdown"))
hl.bind("Print", hl.dsp.exec_cmd(screenshot .. ' && dunstify "Screenshot Saved"'))

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
