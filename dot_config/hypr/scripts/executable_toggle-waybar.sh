#!/usr/bin/env bash
set -uo pipefail

PROCESS_NAME="waybar-closeable"

if pgrep -u "$USER" -f "$PROCESS_NAME" >/dev/null; then
  pkill -u "$USER" -f "$PROCESS_NAME" 2>/dev/null
  exit 0
fi

exec -a "$PROCESS_NAME" waybar