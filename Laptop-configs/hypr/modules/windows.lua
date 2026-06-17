--------------------
---- MY WINDOWS ----
--------------------
hl.window_rule({ match = { class = "^(kitty)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(org.wezfurlong.wezterm)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(alacritty)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(org.mozilla.firefox)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^(nemo)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(net.thunderbird.Thunderbird)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^(org.gnome.Evince)$" }, workspace = "5" })
hl.window_rule({ match = { class = "^(discord)$" }, workspace = "5" })
hl.window_rule({ match = { title = "^(VSCodium)$" }, workspace = "4" })
hl.window_rule({ match = { title = "^(RStudio)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(jetbrains-idea-ce)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = "8" })
hl.window_rule({ match = { title = "^(Jellyfin Media Player)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(chrome-calendar.google.com__calendar_u_0_r-Profile_1)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(Virt-manager)$" }, workspace = "9" })

--- Special Rules

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { title = "^(.*Rofi.*)$" }, stay_focused = true })
hl.window_rule({
  match = { class = "^(jetbrains-studio)$", title = "^win.*" },
  no_initial_focus = true,
})
