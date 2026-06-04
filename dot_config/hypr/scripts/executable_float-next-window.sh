#!/usr/bin/env bash
set -euo pipefail

snapshot="${1:-}"
old=""
if [ -n "$snapshot" ] && [ -f "$snapshot" ]; then
  old="$(cat "$snapshot" 2>/dev/null || true)"
fi

is_old() {
  local addr="$1"
  grep -Fxq "$addr" <<<"$old"
}

cleanup() {
  [ -n "$snapshot" ] && rm -f "$snapshot" 2>/dev/null || true
}
trap cleanup EXIT

# Опрос в течение ~2 секунд (80 итераций по 0.025с)
for _ in $(seq 1 80); do
  clients_json="$(hyprctl -j clients 2>/dev/null || echo '[]')"

  addr="$(jq -r --arg old "$old" '
    def oldlist: ($old | split("\n") | map(select(length > 0)));
    [ .[] | select((.address as $a | oldlist | index($a) | not))

      | select(.mapped == true)
      | select((.class // "") != "fuzzel")
      | .address ][0] // empty
  ' <<<"$clients_json" 2>/dev/null || true)"

  if [ -z "$addr" ]; then
    addr="$(hyprctl -j activewindow 2>/dev/null | jq -r '.address // empty' 2>/dev/null || true)"
    if [ -n "$addr" ] && is_old "$addr"; then
      addr=""
    fi
  fi

  if [ -n "$addr" ]; then
    # Проверяем и добавляем префикс 0x, если его нет (критично для новых версий hyprctl)
    [[ ! "$addr" =~ ^0x ]] && addr="0x$addr"
    win="address:$addr"

    # В актуальном Hyprland вместо hl.dsp используются нативные диспетчеры.
    # Включаем float режим
    hyprctl dispatch togglefloating "$win" >/dev/null 2>&1 || true
    # Меняем размер (синтаксис диспетчера: resizewindowpixel X Y,window)
    hyprctl dispatch resizewindowpixel "1050 720,$win" >/dev/null 2>&1 || true
    # Центрируем окно (синтаксис: centerwindow [окно], но нативно работает только для активного)
    hyprctl dispatch centerwindow "$win" >/dev/null 2>&1 || true
    
    exit 0
  fi
  sleep 0.025
done
