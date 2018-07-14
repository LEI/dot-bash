#!/usr/bin/env bash

if ! hash tmux 2>/dev/null; then
  return
fi

t() {
  if [[ $# -ne 0 ]]; then
    tmux "$@"
  elif [[ -n "$TMUX" ]]; then
    tmux new-session -d
  else
    tmux attach || tmux new-session
  fi
}

tmux_defaults() {
  tmux -f/dev/null -Ltmp lsk
}

# tmux_session_exists() {
#   local session_name="$1"
#   tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"
# }

# tmux_create_detached_session() {
#   local session_name="$1"
#   (TMUX='' tmux new-session -Ad -s "$session_name")
# }

# Attach or create tmux session named the same as current directory
# https://github.com/thoughtbot/dotfiles/blob/master/bin/tat
# tmux_create_if_needed_and_attach() {
#   local path_name="$(basename "$PWD" | tr . -)"
#   local session_name="${1:-$path_name}"
#   if [[ -z "$TMUX" ]]; then
#     tmux new-session -As "$session_name"
#   else
#     if ! tmux_session_exists "$session_name"; then
#       tmux_create_detached_session "$session_name"
#     fi
#     tmux switch-client -t "$session_name"
#   fi
# }

if hash _tmux 2>/dev/null; then
  complete -F _tmux t
fi
