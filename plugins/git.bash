#!/usr/bin/env bash

# Use ~/.gitconfig [alias] to manage shortcuts.

if ! hash git 2>/dev/null; then
  return
fi

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

# [[ -f /usr/local/etc/bash_completion.d/git-completion.bash ]]
# https://stackoverflow.com/a/24665529/7796750
if hash __git_complete 2>/dev/null; then
  __git_complete g __git_main
fi

# https://github.com/defunkt/gist
if ! hash gist 2>/dev/null || [[ "$_custom_gist" -eq 1 ]]; then
  gist() {
    local cmd="$1"
    shift
    local base_dir="$HOME/src/gist.github.com"
    case "$cmd" in
      '') find "$base_dir" -mindepth 2 -maxdepth 2 -type d ;; # List
      clone) git clone "$@" ;;
        # add) git clone "$1" "${2:-$base_dir/...}" ;;
    esac
  }
  _custom_gist=1
fi
