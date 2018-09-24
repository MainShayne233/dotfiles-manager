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

header() {
  echo "-----> $1"
}

value_for_index_and_query() {
  local query=".[$1].$2"
  local path=$(echo $INDEX_JSON_FILE | jq --raw-output $query)
  echo $(eval "echo $path")
}

file_name_for_index() {
  local query="name"
  value_for_index_and_query $1 "$query"
}

system_path_for_index() {
  local query="$SYSTEM.system_path"
  value_for_index_and_query $1 "$query"
}

repo_path_for_index() {
  local query="$SYSTEM.repo_path"
  local rel_dir=$(value_for_index_and_query $1 "$query")
  echo "$DOTFILES_DIR/$rel_dir"
}

there_is_system_configuration_for_index() {
  local query="$SYSTEM | type"
  if [[ $(value_for_index_and_query $1 $query) == 'object' ]]; then
    echo 'true'
  else
    echo 'false'
  fi
}

file_or_dir_exists() {
  local path="$1"
  if [[ -f $path || -d $path ]]; then
    return 0
  else
    return 1
  fi
}

replace_file() {
  local new_file="$1"
  local file_to_replace="$2"

  set +e
  if ! file_or_dir_exists $new_file; then
    header "$new_file does not exist on system"
  elif ! file_or_dir_exists $file_to_replace; then
    header "$file_to_replace does not exist in repo"
  elif diff $new_file $file_to_replace; then
    echo "$new_file matches the repo version"
  else
    echo "Confirm that you want to put your version of $new_file into the repo?"
    read -r
  fi
  set -e
}
