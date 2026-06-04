#!/usr/bin/env bash
set -euo pipefail

# Avoid stacking several lock instances.
if pgrep -x hyprlock >/dev/null 2>&1; then
  exit 0
fi

# Directly run hyprlock. Do not call `loginctl lock-session` from here: when
# hypridle's lock_cmd points to this script, loginctl would recursively trigger
# another lock request before hyprlock appears.
hyprlock
