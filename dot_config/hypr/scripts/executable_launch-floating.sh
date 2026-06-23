#!/usr/bin/env bash
set -euo pipefail

printf -v command '%q ' "$@"
command="${command% }"

hyprctl dispatch exec "[float; center; size 1200 800] $command"