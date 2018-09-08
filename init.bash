#!/usr/bin/env bash

BASH_DIR="$HOME/.bash.d"

load() {
  local path
  for path in "$@"; do
    if [[ -d "$path" ]]; then
      load "$path"/*
    elif [[ -r "$path" ]] && [[ -f "$path" ]]; then # || [[ -L "$f" ]]
      source "$path"
      # else
      #   >&2 printf "%s\n" "$path: No such file or directory"
    fi
  done
}

main() {
  local option
  for option in autocd cdspell checkwinsize cmdhist dirspell extglob globstar histappend nocaseglob; do
    shopt -s "$option" 2>/dev/null
  done

  # Global environment variables
  if [[ -f ~/.exports ]]; then
    source ~/.exports
  fi

  # Append to PATH
  # PATH="$PATH:$HOME/bin"
  if [[ -f ~/.path ]]; then
    source "$HOME"/bin/load_path ~/.path
  fi

  load "$BASH_DIR"/{defaults,aliases/*,functions/*,environment/*,completion,colors,prompt}.bash
  # OS="$(uname -o 2>/dev/null || uname -s | to lower)"

  local file f
  for file in "$BASH_DIR"/plugins/*.bash; do
    f="${file##*/}"
    hash "${f%.bash}" 2>/dev/null && load "$file"
  done

  # [[ -z "$PS1" ]] && PS1='\u at \h in \w\n\$ '
  PROMPT_SYMBOL='› '
  PROMPT_COMMAND='__prompt_command'
  PS1=$(__prompt_string "$PROMPT_SYMBOL") # $ ✓ → ×
  PS2=${PROMPT_SYMBOL:-> }

  load "$HOME"/.bashrc.local
}

main "$@"
