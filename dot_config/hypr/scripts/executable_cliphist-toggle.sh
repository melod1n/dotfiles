#!/usr/bin/env bash
set -uo pipefail

# Toggle: если clipboard-menu уже открыт — закрыть
if pgrep -u "$USER" -f "cliphist-fuzzel-menu" >/dev/null; then
  pkill -u "$USER" -f "cliphist-fuzzel-menu" 2>/dev/null
  exit 0
fi

selection="$(
  cliphist list | bash -c '
    exec -a cliphist-fuzzel-menu fuzzel \
      --dmenu \
      --prompt="Clipboard > " \
      --width=70 \
      --lines=20
  '
)"

# Esc / пустой выбор
[ -z "${selection:-}" ] && exit 0

printf '%s' "$selection" | cliphist decode | wl-copy