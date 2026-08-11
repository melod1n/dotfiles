#!/usr/bin/env bash
SPECIAL="special:scratch"
CURRENT_WS=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [ "$CURRENT_WS" == "$SPECIAL" ]; then
    hyprctl dispatch 'hl.dsp.window.move({ workspace = "+0" })'
else
    hyprctl dispatch "hl.dsp.window.move({ workspace = \"$SPECIAL\" })"
fi