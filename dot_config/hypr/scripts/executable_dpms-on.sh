#!/usr/bin/env bash
set -euo pipefail

# Repeat a few times: on some GPU/monitor combinations the first DPMS wake is ignored.
for _ in 1 2 3 4 5; do
  hyprctl dispatch dpms on || true
  sleep 0.15
done

brightnessctl -r >/dev/null 2>&1 || true
