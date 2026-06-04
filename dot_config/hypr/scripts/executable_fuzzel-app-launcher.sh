#!/usr/bin/env bash
set -u

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
mkdir -p "$state_dir"
log_file="$state_dir/fuzzel-launcher.log"

log() {
  printf '[%s] %s\n' "$(date '+%F %T')" "$*" >> "$log_file"
}

# Обычный запуск в тайлинге через нативный exec
hypr_exec() {
  local cmd="$1"
  log "Executing normal: $cmd"
  hyprctl dispatch exec "$cmd" >> "$log_file" 2>&1
}

# Запуск во float-режиме с использованием встроенных правил exec
hypr_exec_float() {
  local cmd="$1"
  log "Executing float: $cmd"
  
  # Нативно открывает приложение сразу во float, по центру и с нужным размером.
  # Это избавляет от необходимости использовать старый float-launch.sh и поллеры.
  hyprctl dispatch exec "[float; center; size 1050 720]" "$cmd" >> "$log_file" 2>&1
}

make_temp_config() {
  local src="$1"
  local dst="$2"

  if [[ -f "$src" ]]; then
    cp "$src" "$dst"
  else
    : > "$dst"
  fi

  cat >> "$dst" <<'INI'

# --- temporary overrides injected by ~/.config/hypr/scripts/fuzzel-app-launcher.sh ---
[key-bindings]
# Отключаем дефолтное действие на Shift+Enter, чтобы fuzzel вернул код 10 (custom-1)
execute-input=none
custom-1=Shift+Return Shift+KP_Enter
INI
}

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cmd_file="$tmpdir/selected-command"
tmp_config="$tmpdir/fuzzel.ini"
base_config="${XDG_CONFIG_HOME:-$HOME/.config}/fuzzel/fuzzel.ini"
capture_script="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/fuzzel-capture-launch.sh"

make_temp_config "$base_config" "$tmp_config"

: > "$cmd_file"
log "starting fuzzel; base_config=$base_config tmp_config=$tmp_config"

fuzzel --config "$tmp_config" --launch-prefix "$capture_script $cmd_file" "$@"
code=$?

cmd=""
if [[ -s "$cmd_file" ]]; then
  cmd="$(cat "$cmd_file")"
fi

log "fuzzel exited code=$code cmd=$cmd"

if [[ -z "$cmd" ]]; then
  exit "$code"
fi

case "$code" in
  10)
    log "launching FLOAT via native exec rules"
    hypr_exec_float "$cmd"
    ;;
  0)
    log "launching normal"
    hypr_exec "$cmd"
    ;;
  *)
    log "not launching because fuzzel exit code is not handled: $code"
    exit "$code"
  fi
