#!/usr/bin/env bash
set -euo pipefail

# Emergency recovery bind. Do not abort if the off part fails: the important part is trying to wake outputs back up.
hyprctl dispatch dpms off || true
sleep 1
for _ in 1 2 3 4 5; do
  hyprctl dispatch dpms on || true
  sleep 0.15
done
brightnessctl -r >/dev/null 2>&1 || true
