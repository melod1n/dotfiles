#!/usr/bin/env bash

if ! hyprctl activewindow | grep -q 'grouped: 0$'; then
    hyprctl dispatch changegroupactive f
else
    hyprctl dispatch cyclenext
fi
