hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 6,

        border_size = 2,

        float_gaps = 12,

        col = {
            active_border = { colors={ "rgba(8b5cf6aa)" }, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },

        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle"
    },

    dwindle = {
        force_split = 0,
        preserve_split = true,
        smart_split = false,

        precise_mouse_move = true,
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "easeOutQuint" })
