#!/usr/bin/env bash

if ! hash pass 2>/dev/null; then
  return
fi

# Search hidden files by default
# alias ag="ag --hidden --path-to-ignore ~/.agignore"
alias ag="ag --hidden --ignore .git" # -g \"\""

if [[ "$(uname)" = "Darwin" ]] && command -v brew &>/dev/null; then
  BREW_PREFIX=$(brew --prefix)
  if [[ -f "$BREW_PREFIX"/etc/bash_completion ]]; then
    source "$BREW_PREFIX"/etc/bash_completion
  fi
fi
