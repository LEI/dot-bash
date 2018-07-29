#!/usr/bin/env bash

if ! hash brew 2>/dev/null; then
  return
fi

# Disable Google Analytics
HOMEBREW_NO_ANALYTICS=1

# Change default location of Homebrew Cask applications
#HOMEBREW_CASK_OPTS="--appdir=/Applications" #--caskroom=/etc/Caskroom
