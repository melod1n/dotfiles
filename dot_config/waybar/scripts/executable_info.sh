#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="/tmp/waybar-info-expanded"

if ! command -v jq >/dev/null 2>&1; then
  echo '{"text":"ℹ jq?","tooltip":"jq not found"}'
  exit 0
fi

jq_field() {
  echo "$1" | jq -r "$2 // \"N/A\"" 2>/dev/null || echo "N/A"
}

# CPU (uses existing cpu.sh — accurate, includes 0.35s sampling)
cpu_json=$(timeout 2 bash ~/.config/waybar/scripts/cpu.sh 2>/dev/null || echo '{}')
cpu_pct=$(jq_field "$cpu_json" '.percentage')
cpu_tip=$(jq_field "$cpu_json" '.tooltip')

# GPU (uses existing gpu-nvidia.sh)
gpu_json=$(timeout 3 bash ~/.config/waybar/scripts/gpu-nvidia.sh 2>/dev/null || echo '{}')
gpu_pct=$(jq_field "$gpu_json" '.percentage')
gpu_tip=$(jq_field "$gpu_json" '.tooltip')

# Memory
mem_line=$(free -h | awk '/^Mem:/ {printf "%s/%s", $3, $2}')
mem_used=$(free -h | awk '/^Mem:/ {print $3}')
mem_total=$(free -h | awk '/^Mem:/ {print $2}')
swap_line=$(free -h | awk '/^Swap:/ {printf "%s/%s", $3, $2}')

# Disk
disk_line=$(df -h / | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}')
disk_used=$(df -h / | awk 'NR==2 {print $3}')
disk_total=$(df -h / | awk 'NR==2 {print $2}')
disk_pct=$(df -h / | awk 'NR==2 {print $5}')

# Tooltip always detailed
tooltip=" CPU: ${cpu_pct}%
${cpu_tip}

󰢮 GPU: ${gpu_pct}%
${gpu_tip}

 RAM: ${mem_used} / ${mem_total}
Swap: ${swap_line}

󰋊 Disk: ${disk_used} / ${disk_total} (${disk_pct})"

# Bar text: collapsed or expanded
if [ -f "$STATE_FILE" ]; then
  text=" ${cpu_pct}%  󰢮 ${gpu_pct}%   ${mem_line}  󰋊 ${disk_line}"
else
  text="ℹ"
fi

jq -nc --arg text "$text" --arg tooltip "$tooltip" '{text:$text, tooltip:$tooltip}'
