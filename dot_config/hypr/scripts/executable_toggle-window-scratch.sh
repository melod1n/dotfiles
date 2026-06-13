#!/usr/bin/env bash
SPECIAL="special:scratch"
CURRENT_WS=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [ "$CURRENT_WS" == "$SPECIAL" ]; then
    hyprctl dispatch movetoworkspace +0
else
    hyprctl dispatch movetoworkspace $SPECIAL
fi