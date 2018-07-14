#!/usr/bin/env bash

if ! hash ag 2>/dev/null; then
  return
fi

# Search hidden files by default while respecting .agignore
alias ag="ag --hidden"
