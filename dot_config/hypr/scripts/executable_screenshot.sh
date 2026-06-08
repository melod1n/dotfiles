#!/usr/bin/env bash
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"

grim "$file"
wl-copy --type image/png < "$file"

notify-send "Screenshot" "$file" -t 1500