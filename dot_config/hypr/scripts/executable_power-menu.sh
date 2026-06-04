# #!/usr/bin/env bash

# choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | fuzzel --dmenu --prompt="Power: ")

# case "$choice" in
#   Lock) pidof hyprlock >/dev/null || hyprlock ;;
#   Logout) hyprctl dispatch exit ;;
#   Suspend) systemctl suspend ;;
#   Reboot) systemctl reboot ;;
#   Shutdown) systemctl poweroff ;;
# esac

#!/usr/bin/env bash

set -euo pipefail

choice="$(
  printf '%s\n' \
    "Lock" \
    "Logout" \
    "Suspend" \
    "Reboot" \
    "Shutdown" |
  fuzzel --dmenu \
    --prompt="Power: " \
    --width=24 \
    --lines=5
)"

case "$choice" in
  "Lock")
    pidof hyprlock >/dev/null || hyprlock
    ;;

  "Logout")
    hyprshutdown \
      --top-label "Logging out..."
    ;;

  "Suspend")
    pidof hyprlock >/dev/null || hyprlock &
    sleep 1
    systemctl suspend
    ;;

  "Reboot")
    hyprshutdown \
      --top-label "Restarting..." \
      --post-cmd "systemctl reboot"
    ;;

  "Shutdown")
    hyprshutdown \
      --top-label "Shutting down..." \
      --post-cmd "systemctl poweroff"
    ;;

  *)
    exit 0
    ;;
esac