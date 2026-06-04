#!/usr/bin/env bash
set -euo pipefail

# Hyprland 0.55+ uses Lua dispatch syntax even from hyprctl.
# `hyprctl dispatch dpms off` is parsed as invalid Lua: hl.dispatch(dpms off).
hyprctl dispatch dpms off
