#!/usr/bin/env bash
set -euo pipefail

need() {
    command -v "$1" >/dev/null 2>&1 || {
        notify-send "Hyprland" "auto-window-rules: missing $1" >/dev/null 2>&1 || true
        exit 0
    }
}

need hyprctl
need jq
need socat

# Актуальный путь к сокету событий
socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

is_browser_class() {
    [[ "$1" =~ ^(google-chrome|Google-chrome|chromium|Chromium|brave-browser|Brave-browser|vivaldi-stable|firefox|Firefox)$ ]]
}

is_pip_title() {
    [[ "$1" =~ ^(Picture\ in\ picture|Picture-in-Picture|Картинка\ в\ картинке|PiP).*$ ]]
}

is_android_float_class() {
    [[ "$1" =~ ^(emulator|Android\ Emulator|sun-awt-X11-XFramePeer)$ ]]
}

apply_rules_for_addr() {
    local addr="$1"
    [[ -z "$addr" ]] && return 0

    # Проверяем, что адрес начинается с 0x, если нет — добавляем (требование новых hyprctl)
    [[ ! "$addr" =~ ^0x ]] && addr="0x$addr"

    local client class title floating pinned
    client="$(hyprctl clients -j | jq -r --arg addr "$addr" '.[] | select(.address == $addr)')"
    [[ -z "$client" || "$client" == "null" ]] && return 0

    class="$(jq -r '.class // ""' <<<"$client")"
    title="$(jq -r '.title // ""' <<<"$client")"
    floating="$(jq -r '.floating // false' <<<"$client")"
    pinned="$(jq -r '.pinned // false' <<<"$client")"

    # Специфичные правила для Picture-in-Picture браузеров
    if is_browser_class "$class" && is_pip_title "$title"; then
        [[ "$floating" != "true" ]] && hyprctl dispatch togglefloating "address:$addr"
        [[ "$pinned" != "true" ]] && hyprctl dispatch pin "address:$addr"

        # В актуальных версиях setprop — это самостоятельная подкоманда hyprctl, а не диспетчер
        hyprctl setprop "address:$addr" minsize 240 135
        hyprctl setprop "address:$addr" maxsize 640 360
        
        # Диспетчер блокировки групп
        hyprctl dispatch denywindowfromgroup "on" "address:$addr"
        return 0
    fi

    # Специфичные правила для Android-эмуляторов
    if is_android_float_class "$class"; then
        [[ "$floating" != "true" ]] && hyprctl dispatch togglefloating "address:$addr"
        hyprctl dispatch denywindowfromgroup "on" "address:$addr"
        return 0
    fi
}

handle_event() {
    local line="$1"
    local event="${line%%>>*}"
    local data="${line#*>>}"

    case "$event" in
        openwindow)
            # Структура: WINDOWADDRESS,WORKSPACENAME,WINDOWCLASS,WINDOWTITLE
            apply_rules_for_addr "${data%%,*}"
            ;;
        windowtitle|windowtitlev2)
            # Структура: WINDOWADDRESS(,WINDOWTITLE)
            apply_rules_for_addr "${data%%,*}"
            ;;
    esac
}

# Однократное применение к уже запущенным окнам
hyprctl clients -j | jq -r '.[].address' | while read -r addr; do
    apply_rules_for_addr "$addr"
done

# Бесконечный цикл прослушивания сокета
socat -U - UNIX-CONNECT:"$socket" | while IFS= read -r line; do
    handle_event "$line"
done
