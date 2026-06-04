#!/usr/bin/env bash
set -u

cmd_file="${1:?missing command file}"
shift || true

# fuzzel launch-prefix passes the selected .desktop Exec command as argv.
# Do not launch here: only capture the command. The wrapper decides whether
# it should be normal or floating after fuzzel exits and exposes custom-N code.
printf '%s\n' "$*" > "$cmd_file"
exit 0
