#!/usr/bin/env bash

BASH_DIR="$HOME/.bash.d"

load() {
  local path
  for path in "$@"
  do
    if [[ -d "$path" ]]
    then load "$path"/*
    elif [[ -r "$path" ]] && [[ -f "$path" ]] # || [[ -L "$f" ]]
    then source "$path"
    # else >&2 printf "%s\n" "$path: No such file or directory"
    fi
  done
}

main() {
  local option
  for option in autocd cdspell checkwinsize extglob globstar histappend nocaseglob
  do shopt -s "$option" 2> /dev/null
  done

  # aliases,exports,functions,path,prompt
  load "$BASH_DIR"/*.bash
  # OS="$(uname -o 2>/dev/null || uname -s | to lower)"

  local file f
  for file in $BASH_DIR/plugins/*.bash
  do f="${file##*/}"
    hash "${f%.bash}" 2>/dev/null && source "$file"
  done

  # [[ -z "$PS1" ]] && PS1='\u at \h in \w\n\$ '
  PROMPT_SYMBOL='› '
  PROMPT_COMMAND='__prompt_command'
  PS1=$(__prompt_string "$PROMPT_SYMBOL") # $ ✓ → ×
  PS2=${PROMPT_SYMBOL:-> }

  load "$HOME"/.bashrc.local
}

main "$@"
