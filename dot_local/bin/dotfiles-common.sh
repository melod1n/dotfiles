#!/usr/bin/env bash

dotfiles_notify() {
  local type="$1"
  local title="$2"
  local body="${3:-}"

  if [[ -n "${DOTFILES_NOTIFY:-}" && -x "$DOTFILES_NOTIFY" ]]; then
    "$DOTFILES_NOTIFY" "$type" "$title" "$body" || true
  else
    printf '[%s] %s\n%s\n' "$type" "$title" "$body" >&2
  fi
}

dotfiles_fail() {
  dotfiles_notify error "${DOTFILES_TITLE:-Dotfiles}" "$1"
  exit 1
}

dotfiles_need_cmd() {
  command -v "$1" >/dev/null 2>&1 || dotfiles_fail "Missing command: $1"
}

dotfiles_source_dir() {
  local source_dir

  source_dir="$(chezmoi source-path 2>/dev/null || true)"
  [[ -n "$source_dir" ]] || dotfiles_fail "Cannot detect chezmoi source path"
  [[ -d "$source_dir/.git" ]] || dotfiles_fail "Chezmoi source is not a git repository: $source_dir"

  printf '%s\n' "$source_dir"
}
