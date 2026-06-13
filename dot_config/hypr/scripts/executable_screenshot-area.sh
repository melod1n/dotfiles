#!/usr/bin/env bash
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"

hyprpicker -r -z >/dev/null 2>&1 &
picker_pid=$!

cleanup() {
  kill "$picker_pid" 2>/dev/null || true
}
trap cleanup EXIT

sleep 0.15

geom="$(slurp -d)" || exit 0

grim -g "$geom" "$file"
wl-copy --type image/png < "$file"

$HOME/.config/hypr/notify/notify.sh normal "Screenshot" "$file"
