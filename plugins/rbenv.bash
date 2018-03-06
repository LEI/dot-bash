#!/usr/bin/env bash

if ! hash rbenv 2>/dev/null || [[ -n "${RBENV_SHIMS:-}" ]]
then return
fi

export RBENV_SHELL=bash
export RBENV_SHIMS="$HOME/.rbenv/shims"
pathmunge "$RBENV_SHIMS" before
RBENV_BASH_COMPLETION="$(brew --cellar)/rbenv/$(rbenv --version | cut -d ' ' -f2)/completions/rbenv.bash"
source "$RBENV_BASH_COMPLETION"
command rbenv rehash 2>/dev/null
