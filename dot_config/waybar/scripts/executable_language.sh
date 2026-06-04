#!/usr/bin/env bash
set -euo pipefail

if ! command -v hyprctl >/dev/null 2>&1; then
  printf '{"text":"??","tooltip":"hyprctl not found","class":"unknown"}\n'
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  active="$(hyprctl devices 2>/dev/null | awk '/active keymap:/ { sub(/^[[:space:]]*active keymap:[[:space:]]*/, ""); print; exit }')"
else
  active="$(hyprctl devices -j 2>/dev/null | jq -r '[.keyboards[] | select(.main == true)][0].active_keymap // [.keyboards[]][0].active_keymap // empty')"
fi

case "${active,,}" in
  *russian*|*ru*)
    text="🇷🇺"; cls="ru" ;;
  *english*|*us*|*en*)
    text="🇺🇸"; cls="us" ;;
  *german*|*de*)
    text="🇩🇪"; cls="de" ;;
  *)
    text="${active:-??}"; cls="unknown" ;;
esac

# JSON-safe tooltip via jq if available; otherwise fallback to plain flag only.
if command -v jq >/dev/null 2>&1; then
  jq -nc --arg text "$text" --arg tooltip "${active:-unknown}" --arg cls "$cls" '{text:$text, tooltip:$tooltip, class:$cls}'
else
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "${active:-unknown}" "$cls"
fi
