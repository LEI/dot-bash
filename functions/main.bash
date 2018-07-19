#!/usr/bin/env bash

mkd() {
  [[ $# -ne 1 ]] && return 1
  mkdir -p "$1"
}

mcd() {
  [[ $# -ne 1 ]] && return 1
  mkd "$1" && cd "$_"
}

to() {
  case "$1" in
    lower) tr "[:upper:]" "[:lower:]" ;;
    upper) tr "[:lower:]" "[:upper:]" ;;
    *) >&2 printf "%s\n" "to: $1: illegal option"; return 1 ;;
  esac
}

tre() { # hash tree 2>/dev/null
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}
