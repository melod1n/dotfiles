#!/usr/bin/env bash

if ! hyprctl activewindow | grep -q 'grouped: 0$'; then
    hyprctl dispatch 'hl.dsp.group.next()'
else
    hyprctl dispatch 'hl.dsp.window.cycle_next()'
fi
