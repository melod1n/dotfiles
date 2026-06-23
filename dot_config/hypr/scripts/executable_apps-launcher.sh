#!/usr/bin/env bash
set -uo pipefail

LAUNCH_FLOATING="${1:-false}"
PROCESS_NAME="apps-fuzzel-menu"

if pgrep -u "$USER" -f "$PROCESS_NAME" >/dev/null; then
  pkill -u "$USER" -f "$PROCESS_NAME" 2>/dev/null
  exit 0
fi

fuzzel_args=(
  --prompt="> "
  --width=45
  --lines=20
)

if [[ "$LAUNCH_FLOATING" == "true" ]]; then
  fuzzel_args+=(
    --launch-prefix="$HOME/.config/hypr/scripts/launch-floating.sh"
  )
fi

exec -a "$PROCESS_NAME" fuzzel "${fuzzel_args[@]}"