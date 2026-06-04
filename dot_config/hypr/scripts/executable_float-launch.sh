#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <command...>" >&2
  exit 2
fi

cmd="$*"

# Проверяем наличие hyprctl в системе
command -v hyprctl >/dev/null 2>&1 || {
  # Если гипрctl нет, просто выполняем команду в фоне как обычный шелл-скрипт
  exec sh -lc "$cmd"
}

# В версиях 0.40+ диспетчер exec поддерживает правила в квадратных скобках [ RULES ] перед командой.
# Внутри скобок правила разделяются точкой с запятой.
# Мы передаем: float, центрирование и фиксированный размер (1050x720).
hyprctl dispatch exec "[float; center; size 1050 720]" "$cmd" >/dev/null 2>&1