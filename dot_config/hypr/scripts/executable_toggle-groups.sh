#!/usr/bin/env bash
set -euo pipefail

state_file="${XDG_RUNTIME_DIR:-/tmp}/hypr-groups-enabled"

# Вспомогательная функция для изменения параметров конфигурации
hypr_set() {
    hyprctl keyword "$1" "$2" >/dev/null
}

if [[ ! -f "$state_file" ]]; then
    touch "$state_file"
    
    # Включаем группировку через нативную команду 'hyprctl keyword'
    hypr_set "group:auto_group" "true"
    hypr_set "group:drag_into_group" "1"
    hypr_set "group:merge_groups_on_drag" "true"
    hypr_set "group:merge_groups_on_groupbar" "true"
    hypr_set "group:merge_floated_into_tiled_on_groupbar" "false"
    hypr_set "group:group_on_movetoworkspace" "false"
    hypr_set "group:groupbar:enabled" "true"

    # Глобально разблокируем группы (аргумент: unlock)
    hyprctl dispatch lockgroups "unlock" >/dev/null 2>&1 || true
    
    notify-send "Hyprland" "Window grouping enabled" -t 1200 2>/dev/null || true
else
    rm -f "$state_file"
    
    # Отключаем группировку
    hypr_set "group:auto_group" "false"
    hypr_set "group:drag_into_group" "0"
    hypr_set "group:merge_groups_on_drag" "false"
    hypr_set "group:merge_groups_on_groupbar" "false"
    hypr_set "group:merge_floated_into_tiled_on_groupbar" "false"
    hypr_set "group:group_on_movetoworkspace" "false"
    hypr_set "group:groupbar:enabled" "false"

    # Глобально блокируем создание новых групп (аргумент: lock)
    hyprctl dispatch lockgroups "lock" >/dev/null 2>&1 || true

    # Разгруппировываем все текущие окна
    if command -v jq >/dev/null 2>&1; then
        hyprctl clients -j |
            jq -r '.[] | select(.grouped | length > 0) | .address' |
            while read -r addr; do
                [[ -z "$addr" || "$addr" == "null" ]] && continue
                
                # Добавляем префикс 0x к hex-адресу окна, если его нет
                [[ ! "$addr" =~ ^0x ]] && addr="0x$addr"
                
                # Нативный диспетчер для вывода окна из группы требует сначала сфокусироваться на нем
                hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1 || true
                hyprctl dispatch moveoutofgroup "" >/dev/null 2>&1 || true
            done
    fi

    notify-send "Hyprland" "Window grouping disabled" -t 1200 2>/dev/null || true
fi
