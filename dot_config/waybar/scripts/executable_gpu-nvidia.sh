#!/usr/bin/env bash
set -euo pipefail

json() {
  local text="$1"
  local tooltip="$2"
  local class="$3"
  local percentage="${4:-0}"

  jq -nc \
    --arg text "$text" \
    --arg tooltip "$tooltip" \
    --arg class "$class" \
    --argjson percentage "$percentage" \
    '{text:$text, tooltip:$tooltip, class:$class, percentage:$percentage}'
}

trim() {
  awk '{$1=$1; print}' <<< "${1:-}"
}

num_or_zero() {
  local value
  value="$(trim "${1:-}")"

  if [[ "$value" =~ ^[0-9]+$ ]]; then
    echo "$value"
  else
    echo 0
  fi
}

if ! command -v jq >/dev/null 2>&1; then
  printf '{"text":"󰢮 jq N/A","tooltip":"jq не найден","class":"missing","percentage":0}\n'
  exit 0
fi

if ! command -v nvidia-smi >/dev/null 2>&1; then
  json "󰢮 N/A" "nvidia-smi не найден" "missing" 0
  exit 0
fi

raw="$(
  nvidia-smi \
    --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total \
    --format=csv,noheader,nounits 2>/dev/null \
    | head -n1 || true
)"

if [[ -z "$raw" ]]; then
  json "󰢮 ERR" "Не удалось получить данные GPU" "error" 0
  exit 0
fi

IFS=',' read -r name util temp mem_used mem_total <<< "$raw"

name="$(trim "$name")"
util="$(num_or_zero "$util")"
temp="$(num_or_zero "$temp")"
mem_used="$(num_or_zero "$mem_used")"
mem_total="$(num_or_zero "$mem_total")"

vram_percent=0
if (( mem_total > 0 )); then
  vram_percent=$(( mem_used * 100 / mem_total ))
fi

class="normal"

if (( temp >= 80 )); then
  class="critical"
elif (( temp >= 70 )); then
  class="warning"
elif (( util >= 85 || vram_percent >= 85 )); then
  class="busy"
fi

text="󰢮   ${util}%   ${temp}°C     ${vram_percent}%"

tooltip="󰢮   ${name}
   GPU загрузка: ${util}%
  Температура: ${temp}°C
󰍛   VRAM: ${mem_used} / ${mem_total} MiB (${vram_percent}%)"

json "$text" "$tooltip" "$class" "$util"
