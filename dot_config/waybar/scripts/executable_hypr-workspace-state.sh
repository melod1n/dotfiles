#!/usr/bin/env bash
set -euo pipefail

id="${1:?workspace id required}"

need() { command -v "$1" >/dev/null 2>&1; }

if ! need hyprctl || ! need jq; then
    printf '{"text":"%s","class":"error","tooltip":"missing hyprctl or jq"}\n' "$id"
    exit 0
fi

active="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty' 2>/dev/null || true)"

if [[ "$active" == "$id" ]]; then
    class="active"
else
    if hyprctl workspaces -j 2>/dev/null | jq -e --argjson id "$id" 'any(.[]; (.id == $id) and ((.windows // 0) > 0))' >/dev/null 2>&1; then
        class="occupied"
    else
        class="empty"
    fi
fi

jq -cn --arg text "$id" --arg class "$class" --arg tooltip "Workspace $id" \
    '{text:$text,class:$class,tooltip:$tooltip}'
