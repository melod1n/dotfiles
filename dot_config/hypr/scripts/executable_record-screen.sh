#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PIDFILE="$RUNTIME_DIR/wf-recorder-region.pid"
OUTFILE="$RUNTIME_DIR/wf-recorder-region.path"
LOGFILE="$RUNTIME_DIR/wf-recorder-region.log" # Перенесено в изолированный RUNTIME_DIR

notify() {
    $HOME/.config/hypr/notify/notify.sh normal "$@"
}

is_recording() {
    [[ -f "$PIDFILE" ]] || return 1
    local pid
    pid="$(cat "$PIDFILE" 2>/dev/null || true)"
    [[ -n "$pid" ]] || return 1
    kill -0 "$pid" 2>/dev/null || return 1
    ps -p "$pid" -o comm= 2>/dev/null | grep -q "wf-recorder"
}

if is_recording; then
    pid="$(cat "$PIDFILE")"
    file="$(cat "$OUTFILE" 2>/dev/null || true)"

    kill -INT "$pid" 2>/dev/null || true
    sleep 0.7

    rm -f "$PIDFILE" "$OUTFILE"

    if [[ -n "$file" && -f "$file" ]]; then
        printf '%s' "$file" | wl-copy
        notify "Запись остановлена" "$file"
    else
        notify "Запись остановлена"
    fi

    exit 0
fi

PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"

# TODO: add folder with current date
SAVE_DIR="$PICTURES_DIR/Screenshots"
mkdir -p "$SAVE_DIR"

FILE="$SAVE_DIR/recording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"

notify "Запись началась" "Super + Shift + Print — остановить"

wf-recorder -f "$FILE" >"$LOGFILE" 2>&1 &
pid="$!"

echo "$pid" > "$PIDFILE"
echo "$FILE" > "$OUTFILE"

disown "$pid"
