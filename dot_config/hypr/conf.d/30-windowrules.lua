local vars = dofile((os.getenv("HOME") or "") .. "/.config/hypr/conf.d/00-variables.lua")

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "all-modals",
    match = { modal = true },
    force_rgbx = true,
    float = true,
    center = true,
    dim_around = true
})

hl.window_rule({ match = { class = "^(dialog)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(.*[pP]opup.*)$" }, stay_focused = true })

hl.window_rule({
    name = "localsend-modal",
    match = { class = "localsend" },
    float = true,
    center = true,
    size = { 900, 720 },
})

hl.window_rule({
    name = "blueman-modal",
    match = { class = "^(blueman-manager)$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.3", "monitor_h * 0.4" },
})

hl.window_rule({
    name = "jetbrains-welcome-modal",
    match = { title = vars.jetbrainsWelcomeTitles },
    float = true,
    center = true,
    size = { "monitor_w * 0.4", "monitor_h * 0.4" },
})

hl.window_rule({
    name = "bitwarden-modal",
    match = { class = "^(Bitwarden)$" },
    float = true,
    center = true,
    size = { "monitor_w * 0.4", "monitor_h * 0.4" },
})

hl.window_rule({
    name = "bitwarden-browser-modal",
    match = {
        class = "^brave",
        title = "Bitwarden",
    },
    float = true,
    size = { "monitor_w * 0.3", "monitor_h * 0.6" },
})

hl.window_rule({
    name = "auth-modals-classes",
    match = { class = vars.authDialogClasses },
    float = true,
    center = true,
    stay_focused = true,
    dim_around = true,
    group = "deny",
    keep_aspect_ratio = true,
    size = { 520, 260 },
})

hl.window_rule({
    name = "browsers-pip-modals",
    match = { title = vars.pipTitles },
    float = true,
    pin = true,
    group = "deny",
    keep_aspect_ratio = true,
    no_initial_focus = true,
    min_size = { 240, 135 },
    max_size = { 640, 360 },
})

hl.window_rule({
    name = "xdg-portal-modals",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
    center = true,
    stay_focused = true,
    group = "deny",
    keep_aspect_ratio = true,
    size = { "monitor_w * 0.55", "monitor_h * 0.65" },
})

hl.window_rule({
    name = "android-emulator-modals",
    match = { class = vars.androidFloatingClasses },
    float = true,
    keep_aspect_ratio = true,
    persistent_size = true,
    no_shadow = true,
    no_blur = true,
})

hl.window_rule({
    name = "yandex-music",
    match = { class = "^(YandexMusic)$" },
    float = true,
    center = true,
    size = { 1300, 740 },
})

hl.window_rule({
    name = "feishin-music",
    match = { class = "^(feishin)$" },
    float = true,
    center = true,
    size = { 1300, 740 },
})

hl.window_rule({
    name = "yazi",
    match = { class = "yazi" },
    float = true,
    size = { "monitor_w * 0.75", "monitor_h * 0.75" },
    center = true,
})

hl.window_rule({
    name = "happ",
    match = { class = "Happ" },
    float = true,
    size = { 1000, 640 },
})

hl.window_rule({
    name = "flclashx",
    match = { class = "com.follow.clashx" },
    float = true,
    size = { 380, 720 },
})

hl.window_rule({
    name = "kde-picker",
    match = { class = "org.freedesktop.impl.portal.desktop.kde" },
    size = { 1000, 640 },
})

hl.window_rule({
    name = "rustdesk-as-modal",
    match = {
        class = "^(rustdesk)$",
        -- title = "^(RustDesk)$",
    },
    float = true,
    center = true,
    min_size = { 1600, 900 },
})
