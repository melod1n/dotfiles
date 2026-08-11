hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP GTK_THEME QT_QPA_PLATFORMTHEME QT_WAYLAND_DISABLE_WINDOWDECORATION XCURSOR_THEME XCURSOR_SIZE SSH_AUTH_SOCK GNOME_KEYRING_CONTROL")

    -- hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,pkcs11")

    hl.exec_cmd("dex -a -s ~/.config/autostart/")

    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    hl.exec_cmd("pidof hypridle || hypridle")

    hl.exec_cmd("~/.config/hypr/scripts/toggle-waybar.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("playerctld daemon")
    hl.exec_cmd("swaybg -c 11111b")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("wl-clip-persist --clipboard regular")

    hl.exec_cmd("hyprpaper")

    hl.exec_cmd("hyprsunset")

    hl.exec_cmd("udiskie --automount --tray --no-notify")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop hyprland-session.target")
end)
