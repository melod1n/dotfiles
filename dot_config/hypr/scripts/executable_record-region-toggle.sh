#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"

PIDFILE="$RUNTIME_DIR/wf-recorder-region.pid"
OUTFILE="$RUNTIME_DIR/wf-recorder-region.path"
BORDER_PIDFILE="$RUNTIME_DIR/wf-recorder-region-border.pid"

BORDER_SIZE=4
BORDER_COLOR="ff5555ff"

notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send "$@" -t 1500
}

is_recording() {
    [[ -f "$PIDFILE" ]] || return 1

    local pid
    pid="$(cat "$PIDFILE" 2>/dev/null || true)"

    [[ -n "$pid" ]] || return 1
    kill -0 "$pid" 2>/dev/null || return 1
    ps -p "$pid" -o comm= 2>/dev/null | grep -q "wf-recorder"
}

stop_border() {
    if [[ -f "$BORDER_PIDFILE" ]]; then
        local border_pid
        border_pid="$(cat "$BORDER_PIDFILE" 2>/dev/null || true)"

        if [[ -n "$border_pid" ]]; then
            kill "$border_pid" 2>/dev/null || true
        fi

        rm -f "$BORDER_PIDFILE"
    fi
}

start_border() {
    local geometry="$1"

    if [[ ! "$geometry" =~ ^([0-9]+),([0-9]+)[[:space:]]+([0-9]+)x([0-9]+)$ ]]; then
        return 0
    fi

    local x="${BASH_REMATCH[1]}"
    local y="${BASH_REMATCH[2]}"
    local w="${BASH_REMATCH[3]}"
    local h="${BASH_REMATCH[4]}"

    local bx=$((x - BORDER_SIZE))
    local by=$((y - BORDER_SIZE))
    local bw=$((w + BORDER_SIZE * 2))
    local bh=$((h + BORDER_SIZE * 2))

    (( bx < 0 )) && bx=0
    (( by < 0 )) && by=0

    rm -f "$BORDER_PIDFILE"

    local border_cmd="$HOME/.config/hypr/scripts/recording-border.py $bw $bh $BORDER_SIZE $BORDER_PIDFILE $BORDER_COLOR"

    # В актуальном Hyprland правила передаются внутри квадратных скобок [ RULES ].
    # Разделитель правил — точка с запятой (;). 
    # Включаем float, pin, отключаем фокус, анимации, блюр, тени, задаем точный размер и позицию.
    hyprctl dispatch exec "[float; pin; nofocus; noanim; noblur; noshadow; move $bx $by; size $bw $bh]" "$border_cmd" >/dev/null
}

if is_recording; then
    pid="$(cat "$PIDFILE")"
    file="$(cat "$OUTFILE" 2>/dev/null || true)"

    kill -INT "$pid" 2>/dev/null || true
    sleep 0.7

    stop_border

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
SAVE_DIR="$PICTURES_DIR/Screenshots"
mkdir -p "$SAVE_DIR"

FILE="$SAVE_DIR/recording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"

GEOMETRY="$(slurp -b '#00000066' -c '#ff5555ff' -w 3 -f '%x,%y %wx%h')" || exit 0
[[ -n "$GEOMETRY" ]] || exit 0

start_border "$GEOMETRY"

notify "Запись началась" "Shift + Print — остановить"

wf-recorder --geometry "$GEOMETRY" -f "$FILE" >/tmp/wf-recorder-region.log 2>&1 &
pid="$!"

echo "$pid" > "$PIDFILE"
echo "$FILE" > "$OUTFILE"

disown "$pid"
