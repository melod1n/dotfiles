#!/usr/bin/env bash
set -euo pipefail

printf -v command '%q ' "$@"
command="${command% }"

hyprctl dispatch "hl.dsp.exec_cmd([==[$command]==], {
    float = true,
    center = true,
    size = { 1200, 800 },
})"