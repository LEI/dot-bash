#!/usr/bin/env bash

if ! hash go 2>/dev/null; then
  return
fi

export GOPATH="$HOME/go" # ~/Projects?
# export GOROOT="$HOME/go"
pathmunge "$GOPATH/bin" after
