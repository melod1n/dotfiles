#!/usr/bin/env bash
set -euo pipefail

id="${1:?workspace id required}"

hyprctl dispatch "hl.dsp.focus({ workspace = \"$id\" })" >/dev/null 2>&1 || true
pkill -RTMIN+8 waybar >/dev/null 2>&1 || true
