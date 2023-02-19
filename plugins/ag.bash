#!/usr/bin/env bash

if ! hash ag 2>/dev/null; then
  return
fi

# Search hidden files by default
# alias ag="ag --hidden --path-to-ignore ~/.agignore"
alias ag="ag --hidden --ignore .git" # -g \"\""
