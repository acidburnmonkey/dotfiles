require("modules.autostart")
require("modules.keybinds")
require("modules.windows")
require("modules.workspaces")

-------------------
---- MONITORS ----
-------------------
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = "auto" })

------------------
---- XWAYLAND ----
------------------
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "caps:escape, XF86AudioPlay:F9, compose:rctrl",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = {
            natural_scroll = false,
        },
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in       = 3,
        gaps_out      = 11,
        border_size   = 2,
        col           = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout        = "dwindle",
        allow_tearing = false,
    },
})

hl.config({
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
    },
})

-- Enable blur for waybar (was: layerrule = blur on, match:namespace waybar)
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })

-----------------------
---- ANIMATIONS ----
-----------------------
hl.config({ animations = { enabled = true } })

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- you probably want this
    },
})

----------------
---- MISC ----
----------------
hl.config({
    misc = {
        disable_splash_rendering = true,
        disable_hyprland_logo    = true,
    },
})

-- Example per-device config
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
