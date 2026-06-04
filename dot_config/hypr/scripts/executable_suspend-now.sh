#!/usr/bin/env bash
set -euo pipefail

"${HOME}/.config/hypr/scripts/lock-now.sh" >/dev/null 2>&1 &
sleep 0.35
systemctl suspend
