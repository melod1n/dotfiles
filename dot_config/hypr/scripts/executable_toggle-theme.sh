#!/usr/bin/env bash
set -euo pipefail

NEW_THEME=$(darkman toggle)

$HOME/.config/hypr/notify/notify.sh normal "Theme changed: $NEW_THEME"