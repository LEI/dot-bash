#!/usr/bin/env bash

# Append ~/bin
if [[ -d "$HOME/bin" ]]; then
  pathmunge "$HOME/bin" after
fi

if [[ -d "/usr/local/sbin" ]]; then
  pathmunge "/usr/local/sbin" before
fi
