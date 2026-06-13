#!/bin/bash

if pgrep -x "hypridle" > /dev/null
then
    pkill hypridle
    $HOME/.config/hypr/notify/notify.sh low "Caffeine Mode: ON"
else
    hypridle &
    $HOME/.config/hypr/notify/notify.sh low "Caffeine Mode: OFF"
fi
