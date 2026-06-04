#!/bin/bash

if pgrep -x "hypridle" > /dev/null
then
    pkill hypridle
    notify-send "Caffeine Mode: ON" "Screensaver and sleep disabled." -t 1500
else
    hypridle &
    notify-send "Caffeine Mode: OFF" "Screensaver and sleep enabled." -t 1500
fi