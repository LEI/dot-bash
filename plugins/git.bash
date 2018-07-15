#!/usr/bin/env bash

# Use ~/.gitconfig [alias] to manage shortcuts.

if ! hash git 2>/dev/null; then
  return
fi

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}

# [[ -f /usr/local/etc/bash_completion.d/git-completion.bash ]]
if hash _git 2>/dev/null; then
  complete -o bashdefault -o default -o nospace -F _git g # __git_wrap__git_main
fi

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
