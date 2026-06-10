--------------
<<<<<<< HEAD
=======
-- MY WINDOWS --
--------------

-- Workspace assignments
hl.window_rule({ name = "ws-wezterm", match = { class = "^(org.wezfurlong.wezterm)$" }, workspace = 1 })
hl.window_rule({ name = "ws-firefox", match = { class = "^(org.mozilla.firefox)$" }, workspace = 2 })
hl.window_rule({ name = "ws-waterfox", match = { class = "^(waterfox)$" }, workspace = 2 })
hl.window_rule({ name = "ws-nemo", match = { class = "^(nemo)$" }, workspace = 3 })
hl.window_rule({ name = "ws-vscodium", match = { title = "^(VSCodium)$" }, workspace = 4 })
hl.window_rule({ name = "ws-jetbrains", match = { title = "^(jetbrains-idea)$" }, workspace = 4 })
hl.window_rule({ name = "ws-postman", match = { title = "^(Postman)$" }, workspace = 4 })
hl.window_rule({ name = "ws-rstudio", match = { title = "^(RStudio)$" }, workspace = 4 })
hl.window_rule({ name = "ws-obsidian", match = { class = "^(obsidian)$" }, workspace = 5 })
hl.window_rule({ name = "ws-libreoff", match = { class = "^(libreoffice.*)$" }, workspace = 5 })
hl.window_rule({ name = "ws-discord", match = { class = "^(com.discordapp.Discord)$" }, workspace = 5 })
hl.window_rule({ name = "ws-thunderbird", match = { class = "^(net.thunderbird.Thunderbird)$" }, workspace = 7 })
hl.window_rule({ name = "ws-jellyfin", match = { title = "^(Jellyfin Media Player)$" }, workspace = 8 })
hl.window_rule({ name = "ws-gcalendar", match = { class = "^(chrome-calendar.*)$" }, workspace = 8 })
hl.window_rule({ name = "ws-affinity", match = { class = "^(affinity)$" }, workspace = 8 })
hl.window_rule({ name = "ws-tauon", match = { title = "^(Tauon)$" }, workspace = 8 })
hl.window_rule({ name = "ws-steam", match = { class = "^(steam)$" }, workspace = 9 })
hl.window_rule({ name = "ws-virt", match = { class = "^(virt-manager)$" }, workspace = 9 })
hl.window_rule({ name = "ws-krita", match = { class = "^(krita)$" }, workspace = 10 })
hl.window_rule({ name = "ws-inkscape", match = { class = "^(org.inkscape.Inkscape)$" }, workspace = 10 })
hl.window_rule({ name = "ws-sqlite", match = { class = "^(sqlitebrowser)$" }, workspace = 10 })
hl.window_rule({ name = "ws-veracrypt", match = { class = "^(veracrypt)$" }, workspace = 10 })

--------------
>>>>>>> refs/remotes/origin/master
-- Special rules --
--------------

-- Suppress maximize for all windows
hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- No screen share
hl.window_rule({
	name = "no-screen-share-bitwarden",
	match = { class = "^(Bitwarden)$" },
	no_screen_share = true,
})
hl.window_rule({
	name = "no-screen-share-nemo",
	match = { class = "^(Nemo)$" },
	no_screen_share = true,
})

-- Float rules
hl.window_rule({
	name = "float-amberol",
	match = { class = "^(io.bassi.Amberol)$" },
	float = true,
	size = { 413, 689 },
})
hl.window_rule({
	name = "float-qalculate",
	match = { class = "^(qalculate-gtk)$", title = "^(Qalculate!)$" },
	float = true,
})

-- Tile rules
hl.window_rule({
	name = "tile-affinity",
	match = { class = "^(affinity.exe)$" },
	tile = true,
	workspace = 10,
})

-- Android Studio no initial focus
hl.window_rule({
	name = "no-focus-jetbrains",
	match = { class = "^(jetbrains-studio)$", title = "^win.*" },
	no_initial_focus = true,
})
<<<<<<< HEAD

--------------
-- MY WINDOWS --
--------------

-- Workspace assignments
hl.window_rule({ name = "ws-wezterm", match = { class = "^(org.wezfurlong.wezterm)$" }, workspace = 1 })
hl.window_rule({ name = "ws-firefox", match = { class = "^(org.mozilla.firefox)$" }, workspace = 2 })
hl.window_rule({ name = "ws-nemo", match = { class = "^(nemo)$" }, workspace = 3 })
hl.window_rule({ name = "ws-vscodium", match = { title = "^(VSCodium)$" }, workspace = 4 })
hl.window_rule({ name = "ws-postman", match = { title = "^(Postman)$" }, workspace = 4 })
hl.window_rule({ name = "ws-rstudio", match = { title = "^(RStudio)$" }, workspace = 4 })
hl.window_rule({ name = "ws-obsidian", match = { class = "^(obsidian)$" }, workspace = 5 })
hl.window_rule({ name = "ws-libreoff", match = { class = "^(libreoffice.*)$" }, workspace = 5 })
hl.window_rule({ name = "ws-discord", match = { class = "^(com.discordapp.Discord)$" }, workspace = 5 })
hl.window_rule({ name = "ws-thunderbird", match = { class = "^(net.thunderbird.Thunderbird)$" }, workspace = 7 })
hl.window_rule({ name = "ws-jellyfin", match = { title = "^(Jellyfin Media Player)$" }, workspace = 8 })
hl.window_rule({ name = "ws-gcalendar", match = { class = "^(chrome-calendar.*)$" }, workspace = 8 })
hl.window_rule({ name = "ws-affinity", match = { class = "^(affinity)$" }, workspace = 8 })
hl.window_rule({ name = "ws-tauon", match = { title = "^(Tauon)$" }, workspace = 8 })
hl.window_rule({ name = "ws-steam", match = { class = "^(steam)$" }, workspace = 9 })
hl.window_rule({ name = "ws-virt", match = { class = "^(virt-manager)$" }, workspace = 9 })
hl.window_rule({ name = "ws-krita", match = { class = "^(krita)$" }, workspace = 10 })
hl.window_rule({ name = "ws-inkscape", match = { class = "^(org.inkscape.Inkscape)$" }, workspace = 10 })
hl.window_rule({ name = "ws-sqlite", match = { class = "^(sqlitebrowser)$" }, workspace = 10 })
hl.window_rule({ name = "ws-veracrypt", match = { class = "^(veracrypt)$" }, workspace = 10 })
=======
>>>>>>> refs/remotes/origin/master
