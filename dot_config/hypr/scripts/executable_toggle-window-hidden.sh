#!/usr/bin/env bash
set -euo pipefail

need() {
    command -v "$1" >/dev/null 2>&1 || {
        notify-send "Hyprland" "Missing dependency: $1" -t 10000 >/dev/null 2>&1 || true
        exit 1
    }
}

need hyprctl
need jq

win_json="$(hyprctl activewindow -j 2>/dev/null || true)"
addr="$(jq -r '.address // empty' <<<"$win_json")"

# No active window: just toggle scratchpad.
if [[ -z "$addr" || "$addr" == "0x0" ]]; then
    hyprctl dispatch togglespecialworkspace hidden
    exit 0
fi

workspace="$(jq -r '.workspace.name // empty' <<<"$win_json")"

if [[ "$workspace" == "special:hidden" ]]; then
    # Return the focused scratchpad window back to the currently active normal workspace.
    target="$(
        hyprctl monitors -j |
        jq -r '.[] | select(.focused == true) | .activeWorkspace.name // empty' |
        head -n 1
    )"

    if [[ -z "$target" || "$target" == special:* ]]; then
        target="previous_per_monitor"
    fi

    # Native dispatcher replacement for window movement and workspace toggling
    hyprctl dispatch movetoworkspace "$target,address:$addr"
    hyprctl dispatch togglespecialworkspace hidden >/dev/null 2>&1 || true
    notify-send "Hyprland" "Returned window from scratchpad" -t 1500 >/dev/null 2>&1 || true
else
    # Native dispatcher replacement to send window to scratchpad
    hyprctl dispatch movetoworkspace "special:hidden,address:$addr"
    notify-send "Hyprland" "Moved window to scratchpad" -t 1500 >/dev/null 2>&1 || true
fi
