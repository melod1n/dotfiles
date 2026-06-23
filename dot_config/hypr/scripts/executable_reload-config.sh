#!/usr/bin/env bash
set -euo pipefail

hyprctl reload

$HOME/.config/hypr/notify/notify.sh normal "Hyprland config reloaded"