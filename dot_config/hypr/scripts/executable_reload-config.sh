#!/usr/bin/env bash
set -euo pipefail

#bind = $mainMod SHIFT, R, exec, hyprctl reload && notify-send normal "hyprload config reloaded"

hyprctl reload

$HOME/.config/hypr/notify/notify.sh normal "Hyprland config reloaded"