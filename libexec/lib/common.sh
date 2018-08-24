#!/usr/bin/env bash
# shellcheck disable=SC1117
set -CEeuo pipefail
IFS=$'\n\t'
shopt -s extdebug

if [[ $(uname) == "Darwin" ]]; then
  sedf() { command sed -l "$@"; }
else
  sedf() { command sed -u "$@"; }
fi

indent() {
  sedf "s/^/       /"
}

log() {
  echo "$@" | indent
}

tolower() {
  echo "$@" | tr "[:upper:]" "[:lower:]"
}

header() {
  echo "-----> $1"
}

declare -a on_exit_items

on_exit() {
  for i in "${on_exit_items[@]}"; do
    echo "on_exit: $i"
    eval "$i"
  done
}

add_on_exit() {
  local n=${#on_exit_items[*]}
  on_exit_items[$n]="$*"
  if [[ $n -eq 0 ]]; then
    trap on_exit EXIT >&1 >/dev/null
  fi
}

verify_directory() {
  if [[ ! -d "$1" ]]; then
    log "Unable to find directory: $1"
    exit 1
  fi
}

absolute_path() {
  if [[ -d "$1" ]]; then
    cd "$1" || exit 1
    pwd -P
  else
    cd "$(dirname "$1")" || exit 1
    echo "$(pwd -P)/$(basename "$1")"
  fi
}

get_git_branch() {
  git rev-parse --abbrev-ref HEAD
}
