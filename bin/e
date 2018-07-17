#!/usr/bin/env bash

e() {
  if [[ -z "$EDITOR" ]]; then
    >&2 printf "%s" "EDITOR is undefined"
    return 1
  fi
  if [[ $# -ne 0 ]]; then
    $EDITOR "$@"
  else
    $EDITOR .
  fi
}
