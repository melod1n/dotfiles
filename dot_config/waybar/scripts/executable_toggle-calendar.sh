#!/usr/bin/env bash
set -euo pipefail

if command -v gsimplecal >/dev/null 2>&1; then
  if pgrep -x gsimplecal >/dev/null 2>&1; then
    pkill -x gsimplecal
  else
    gsimplecal & disown
  fi
  exit 0
fi

if command -v merkuro-calendar >/dev/null 2>&1; then
  merkuro-calendar & disown
  exit 0
fi

if command -v kalendar >/dev/null 2>&1; then
  kalendar & disown
  exit 0
fi

if command -v gnome-calendar >/dev/null 2>&1; then
  gnome-calendar & disown
  exit 0
fi

if command -v zenity >/dev/null 2>&1; then
  zenity --calendar --title="Calendar" >/dev/null 2>&1 || true
  exit 0
fi

notify-send "Calendar" "Install gsimplecal, merkuro-calendar, kalendar, gnome-calendar or zenity" -t 3500 || true
