#!/usr/bin/env bash
set -euo pipefail

layout="$(
    hyprctl devices -j 2>/dev/null |
    jq -r '
        .keyboards
        | map(select(.main == true))
        | (.[0].active_keymap // empty)
    '
)"

if [[ -z "$layout" ]]; then
    layout="$(
        hyprctl devices -j 2>/dev/null |
        jq -r '.keyboards[0].active_keymap // empty'
    )"
fi

case "$layout" in
    *Russian*|*ru*|*RU*)
        echo '{"text":"RU","tooltip":"Russian","class":"ru"}'
        ;;
    *English*|*US*|*us*)
        echo '{"text":"EN","tooltip":"English","class":"en"}'
        ;;
    *)
        text="${layout:-??}"
        text="${text:0:2}"
        text="$(tr '[:lower:]' '[:upper:]' <<<"$text")"
        echo "{\"text\":\"$text\",\"tooltip\":\"${layout:-Unknown layout}\",\"class\":\"unknown\"}"
        ;;
esac
