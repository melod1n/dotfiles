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

fmt_freq_mhz() {
  local mhz
  mhz="$(num_or_zero "${1:-0}")"

  if (( mhz >= 1000 )); then
    awk -v mhz="$mhz" 'BEGIN {printf "%.1fGHz", mhz / 1000}'
  elif (( mhz > 0 )); then
    echo "${mhz}MHz"
  else
    echo "N/A"
  fi
}

read_cpu_snapshot() {
  local idle_ref_name="$1"
  local total_ref_name="$2"

  local -n idle_ref="$idle_ref_name"
  local -n total_ref="$total_ref_name"

  local label user nice system idle iowait irq softirq steal guest guest_nice
  local idle_all non_idle total

  while read -r label user nice system idle iowait irq softirq steal guest guest_nice _; do
    [[ "$label" =~ ^cpu[0-9]*$ ]] || continue

    user="${user:-0}"
    nice="${nice:-0}"
    system="${system:-0}"
    idle="${idle:-0}"
    iowait="${iowait:-0}"
    irq="${irq:-0}"
    softirq="${softirq:-0}"
    steal="${steal:-0}"

    idle_all=$((idle + iowait))
    non_idle=$((user + nice + system + irq + softirq + steal))
    total=$((idle_all + non_idle))

    idle_ref["$label"]="$idle_all"
    total_ref["$label"]="$total"
  done < /proc/stat
}

get_cpu_temp() {
  local temp=""

  if command -v sensors >/dev/null 2>&1; then
    temp="$(
      sensors 2>/dev/null | awk '
        {
          line=$0
          gsub(/^[[:space:]]+/, "", line)

          if (line ~ /^(Tctl|Tdie|Package id 0|CPU|CPU Temperature):/) {
            if (match(line, /\+?[0-9]+(\.[0-9]+)?°C/)) {
              value = substr(line, RSTART, RLENGTH)
              gsub(/[+°C]/, "", value)
              split(value, parts, ".")
              print parts[1]
              exit
            }
          }
        }
      ' || true
    )"

    if [[ "$temp" =~ ^[0-9]+$ ]]; then
      echo "$temp"
      return
    fi
  fi

  for zone in /sys/class/thermal/thermal_zone*; do
    [[ -r "$zone/temp" && -r "$zone/type" ]] || continue

    local type value
    type="$(tr '[:upper:]' '[:lower:]' < "$zone/type" 2>/dev/null || true)"

    case "$type" in
      *cpu*|*k10temp*|*coretemp*|*x86_pkg_temp*|*zenpower*)
        value="$(cat "$zone/temp" 2>/dev/null || true)"

        if [[ "$value" =~ ^[0-9]+$ ]] && (( value > 10000 && value < 120000 )); then
          echo $((value / 1000))
          return
        fi
        ;;
    esac
  done

  echo 0
}

declare -A FREQ_MHZ_BY_CORE
AVG_MHZ=0

load_cpu_freqs() {
  FREQ_MHZ_BY_CORE=()

  local total_mhz=0
  local count=0

  for dir in /sys/devices/system/cpu/cpu[0-9]*; do
    [[ -d "$dir" ]] || continue

    local core="${dir##*cpu}"
    local file="$dir/cpufreq/scaling_cur_freq"

    [[ -r "$file" ]] || continue

    local khz mhz
    khz="$(cat "$file" 2>/dev/null || true)"

    if [[ "$khz" =~ ^[0-9]+$ ]]; then
      mhz=$((khz / 1000))
      FREQ_MHZ_BY_CORE["$core"]="$mhz"
      total_mhz=$((total_mhz + mhz))
      count=$((count + 1))
    fi
  done

  if (( count > 0 )); then
    AVG_MHZ=$((total_mhz / count))
    return
  fi

  while IFS='=' read -r core mhz; do
    [[ "$core" =~ ^[0-9]+$ && "$mhz" =~ ^[0-9]+$ ]] || continue

    FREQ_MHZ_BY_CORE["$core"]="$mhz"
    total_mhz=$((total_mhz + mhz))
    count=$((count + 1))
  done < <(
    awk -F ':' '
      /^processor/ {
        core=$2
        gsub(/[[:space:]]/, "", core)
      }

      /^cpu MHz/ {
        mhz=$2
        gsub(/^[[:space:]]+/, "", mhz)
        printf "%s=%.0f\n", core, mhz
      }
    ' /proc/cpuinfo 2>/dev/null || true
  )

  if (( count > 0 )); then
    AVG_MHZ=$((total_mhz / count))
  else
    AVG_MHZ=0
  fi
}

if ! command -v jq >/dev/null 2>&1; then
  printf '{"text":" jq N/A","tooltip":"jq не найден","class":"missing","percentage":0}\n'
  exit 0
fi

declare -A IDLE_1 TOTAL_1 IDLE_2 TOTAL_2 USAGE_BY_CPU

read_cpu_snapshot IDLE_1 TOTAL_1
sleep 0.35
read_cpu_snapshot IDLE_2 TOTAL_2

for label in "${!TOTAL_1[@]}"; do
  [[ -n "${TOTAL_2[$label]:-}" ]] || continue

  diff_total=$((TOTAL_2[$label] - TOTAL_1[$label]))
  diff_idle=$((IDLE_2[$label] - IDLE_1[$label]))

  if (( diff_total <= 0 )); then
    USAGE_BY_CPU["$label"]=0
  else
    USAGE_BY_CPU["$label"]=$(( (1000 * (diff_total - diff_idle) / diff_total + 5) / 10 ))
  fi
done

load_cpu_freqs

avg_usage="$(num_or_zero "${USAGE_BY_CPU[cpu]:-0}")"

temp="$(get_cpu_temp)"
temp="$(num_or_zero "$temp")"

avg_mhz="$(num_or_zero "$AVG_MHZ")"
avg_freq="$(fmt_freq_mhz "$avg_mhz")"

class="normal"

if (( temp >= 90 || avg_usage >= 95 )); then
  class="critical"
elif (( temp >= 75 || avg_usage >= 85 )); then
  class="warning"
elif (( avg_usage >= 60 )); then
  class="busy"
fi

if (( temp > 0 )); then
  text="   ${avg_usage}%  󰓅  ${avg_freq}   ${temp}°C"
else
  text="   ${avg_usage}%  󰓅  ${avg_freq}   N/A"
fi

tooltip="   CPU средняя загрузка: ${avg_usage}%
󰓅  Средняя частота: ${avg_freq}"

if (( temp > 0 )); then
  tooltip="${tooltip}
 Температура: ${temp}°C"
else
  tooltip="${tooltip}
 Температура: N/A"
fi

tooltip="${tooltip}

Ядра:"

while IFS= read -r label; do
  [[ "$label" =~ ^cpu[0-9]+$ ]] || continue

  core="${label#cpu}"
  usage="$(num_or_zero "${USAGE_BY_CPU[$label]:-0}")"
  mhz="$(num_or_zero "${FREQ_MHZ_BY_CORE[$core]:-0}")"
  freq="$(fmt_freq_mhz "$mhz")"

  tooltip="${tooltip}
cpu${core}: ${usage}% · ${freq}"
done < <(
  printf '%s\n' "${!USAGE_BY_CPU[@]}" | sort -V
)

json "$text" "$tooltip" "$class" "$avg_usage"
