#!/usr/bin/env bash
set -euo pipefail

PROCESS_NAME="fuzzel-power-menu"

if pgrep -u "$USER" -f "$PROCESS_NAME" >/dev/null; then
    pkill -u "$USER" -f "$PROCESS_NAME" 2>/dev/null
    exit 0
fi

fuzzel_args=(
    --prompt="Power > "
    --width=24
    --lines=6
    --font="JetBrains Mono:size=14"
)

choice="$(
    printf '%s\n' \
        '  Lock' \
        '󰍃  Logout' \
        '󰤄  Suspend' \
        '󰒲  Hibernate' \
        '󰜉  Reboot' \
        '  Shutdown' |
        exec -a "$PROCESS_NAME" fuzzel --dmenu "${fuzzel_args[@]}"
)" || exit 0

case "$choice" in
    *"Lock")
        pidof hyprlock >/dev/null || hyprlock
        ;;

    *"Logout")
        hyprshutdown \
            --top-label "Logging out..."
        ;;

    *"Suspend")
        pidof hyprlock >/dev/null || hyprlock &
        sleep 1
        systemctl suspend
        ;;

    *"Hibernate")
        systemctl hibernate
        ;;

    *"Reboot")
        hyprshutdown \
            --top-label "Restarting..." \
            --post-cmd "systemctl reboot"
        ;;

    *"Shutdown")
        hyprshutdown \
            --top-label "Shutting down..." \
            --post-cmd "systemctl poweroff"
        ;;

    *)
        exit 0
        ;;
esac