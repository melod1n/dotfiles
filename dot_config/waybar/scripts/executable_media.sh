#!/usr/bin/env bash
# Check all players — any Playing or Paused?
playerctl -a status 2>/dev/null | grep -qE '^(Playing|Paused)$' || exit 0

# Get first active player name
player=$(playerctl -a metadata --format '{{status}} {{playerName}}' 2>/dev/null | grep -m1 -E '^(Playing|Paused) ' | cut -d' ' -f2-)
[ -n "$player" ] || exit 0

artist=$(playerctl -p "$player" metadata artist 2>/dev/null || echo "Unknown Artist")
title=$(playerctl -p "$player" metadata title 2>/dev/null || echo "Unknown Title")
echo "$player: $artist - $title"
