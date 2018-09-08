#!/usr/bin/env bash

# Source with OS prefix
source_prefix() {
  local prefix file="$1"
  if [[ "$(uname)" == "Darwin" ]] && command -v brew &>/dev/null; then
    prefix=$(brew --prefix)
  fi
  if [[ -n "$prefix" ]]; then
    if [[ "$file" != /* ]]; then
      file="$prefix/$file"
    elif [[ "$file" == /* ]]; then
      file="$prefix$file"
    fi
  fi
  if [[ ! -f "$file" ]]; then
    return 1
  fi
  source "$file"
}
