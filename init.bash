#!/usr/bin/env bash

BASH_DIR="$HOME/.bash.d"

main() {
  local option
  for option in autocd cdspell checkwinsize cmdhist dirspell extglob globstar histappend nocaseglob; do
    shopt -s "$option" 2>/dev/null
  done

  if [[ -f ~/.sh_profile ]]; then
    # shellcheck disable=SC1090
    source ~/.sh_profile
  fi

  # shellcheck disable=SC1090
  source "$HOME"/bin/load

  load "$BASH_DIR"/{defaults,aliases/*,functions/*,environment/*,completion,colors,prompt}.bash
  # OS="$(uname -o 2>/dev/null || uname -s | to lower)"

  local file f
  for file in "$BASH_DIR"/plugins/*.bash; do
    f="${file##*/}"
    hash "${f%.bash}" 2>/dev/null && load "$file"
  done

  PROMPT_COMMAND="__prompt_command ''"
  PROMPT_DIRTRIM="${PROMPT_DIRTRIM:-3}"
  __set_prompt_string "›"
  # PROMPT_SYMBOL= ✓ → ×
  PS1="${PROMPT}"  # \u@\h \w \s-\v\$
  PS2="${PROMPT2}" # FIXME %_>

  load "$HOME"/.bashrc.local
}

main "$@"
unset main
