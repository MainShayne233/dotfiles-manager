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
  query=".[$1].$2"
  path=$(echo $INDEX_JSON_FILE | jq --raw-output $query)
  echo $(eval "echo $path")
}

file_name_for_index() {
  query="name"
  value_for_index_and_query $1 "$query"
}

system_path_for_index() {
  query="$SYSTEM.system_path"
  value_for_index_and_query $1 "$query"
}

repo_path_for_index() {
  query="$SYSTEM.repo_path"
  rel_dir=$(value_for_index_and_query $1 "$query")
  echo "$DOTFILES_DIR/$rel_dir"
}

there_is_system_configuration_for_index() {
  query="$SYSTEM | type"
  if [[ $(value_for_index_and_query $1 $query) == 'object' ]]; then
    echo 'true'
  else
    echo 'false'
  fi
}
