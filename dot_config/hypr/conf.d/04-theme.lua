hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("XDG_CONFIG_DIRS", "/etc/xdg")
hl.env("XDG_MENU_PREFIX", "arch-")

hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")

hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

hl.config({
    cursor = {
        sync_gsettings_theme = true,
        inactive_timeout = 10,
        enable_hyprcursor = true,

        no_hardware_cursors = 2,
        use_cpu_buffer = 2,
    },
})
