-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	-- Status bar, tray, notifications, cloud, wallpaper, idle
	hl.exec_cmd("waybar & nm-applet & dunst & nextcloud & hyprpaper & hypridle")
	hl.exec_cmd("waybar -c ~/.config/waybar/config2")

	-- DBus environment
	hl.exec_cmd("dbus-update-activation-environment --all")

	-- Polkit agent & keyring
	hl.exec_cmd("/usr/libexec/lxqt-policykit-agent")
	hl.exec_cmd("systemctl --user start gnome-keyring-daemon")

	-- Startup script
	hl.exec_cmd(os.getenv("HOME") .. "/scripts/startup.sh")

	-- F44 fix: import environment into systemd & dbus
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE"
	)
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE"
	)
	hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

-------------------
---- environment ----
-------------------

-- Auth
hl.env("SSH_AUTH_SOCK", "/run/user/1000/ssh-agent.socket")

-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Qt
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Cursors
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- XWayland / Java
hl.env("OGL_DEDICATED_HW_STATE_PER_CONTEXT", "ENABLE_ROBUST")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_STATE_HOME", os.getenv("HOME") .. "/.local/state")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("LIBVIRT_DEFAULT_URI", "qemu:///system")
