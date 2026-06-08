#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/hypr/notify/notify.env"

if [[ -f "$CONFIG" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG"
fi

TYPE="${1:-normal}"
TITLE="${2:-Notification}"
BODY="${3:-}"

case "$TYPE" in
  theme)
    URGENCY="low"
    TIMEOUT="${DOT_NOTIFY_THEME_MS:-1500}"
    HYPR_ICON=1
    HYPR_COLOR="rgb(89b4fa)"
    ;;

  success)
    URGENCY="normal"
    TIMEOUT="${DOT_NOTIFY_SUCCESS_MS:-2500}"
    HYPR_ICON=1
    HYPR_COLOR="rgb(a6e3a1)"
    ;;

  normal)
    URGENCY="normal"
    TIMEOUT="${DOT_NOTIFY_NORMAL_MS:-4000}"
    HYPR_ICON=1
    HYPR_COLOR="rgb(cdd6f4)"
    ;;

  important)
    URGENCY="critical"
    TIMEOUT="${DOT_NOTIFY_IMPORTANT_MS:-0}"
    HYPR_ICON=3
    HYPR_COLOR="rgb(f9e2af)"
    ;;

  error|critical)
    URGENCY="critical"
    TIMEOUT="${DOT_NOTIFY_ERROR_MS:-0}"
    HYPR_ICON=3
    HYPR_COLOR="rgb(ff5555)"
    ;;

  *)
    URGENCY="normal"
    TIMEOUT="${DOT_NOTIFY_NORMAL_MS:-4000}"
    HYPR_ICON=1
    HYPR_COLOR="rgb(cdd6f4)"
    ;;
esac

if [[ "$TIMEOUT" == "0" ]]; then
  HYPR_TIMEOUT="${DOT_NOTIFY_HYPR_INFINITE_MS:-86400000}"
else
  HYPR_TIMEOUT="$TIMEOUT"
fi

BACKEND=hyprctl

if [[ "$DOT_NOTIFY_BACKEND" == "auto" ]]; then
  if command -v hyprctl >/dev/null 2>&1; then
    BACKEND=hyprctl
  elif command -v notify-send >/dev/null 2>&1; then
    BACKEND=notify-send
  else 
    BACKEND=stderr
  fi
else
  # TODO: validate DOT_NOTIFY_VALUE
  BACKEND="$DOT_NOTIFY_BACKEND"
fi

case "$BACKEND" in
  hyprctl)
    MESSAGE="$TITLE"
    if [[ -n "$BODY" ]]; then
      MESSAGE="$MESSAGE: ${BODY//$'\n'/; }"
    fi

    hyprctl notify "$HYPR_ICON" "$HYPR_TIMEOUT" "$HYPR_COLOR" "fontsize:14 $MESSAGE" >/dev/null 2>&1 || true
    ;;

  notify-send)
    notify-send \
      -a dotfiles \
      -u "$URGENCY" \
      -t "$TIMEOUT" \
      "$TITLE" \
      "$BODY"
    ;;

  stderr)
    printf '%s\n%s\n' "$TITLE" "$BODY" >&2
    ;;
esac
