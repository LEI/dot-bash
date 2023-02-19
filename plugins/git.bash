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

# Show changes since last pull
# Usage: changelog [diff]
changelog() {
  local cmd="$1"
  shift
  newline=$'\n'
  reflog="$(git reflog | grep -A1 pull | head -2 | cut -d' ' -f1)"
  case "$cmd" in
  diff) git diff "$@" "${reflog//$newline/..}" ;;
  '' | *) git log --oneline "${reflog//*$newline/}~1..${reflog//$newline*/}" ;;
  esac
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

if hash fzf 2>/dev/null && hash gh 2>/dev/null; then
  gco() {
    git branch --sort=-committerdate | fzf --height=20% | xargs git checkout
  }
fi

# FZF + GitHub CLI to test PRs
# https://github.com/helix-editor/helix/discussions/5883
if hash fzf 2>/dev/null && hash gh 2>/dev/null; then
  ghpr() {
    GH_FORCE_TTY=100% gh pr list --limit 300 |
      fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window 'down,70%' --header-lines 3 |
      awk '{print $1}' |
      xargs gh pr checkout
  }
fi
