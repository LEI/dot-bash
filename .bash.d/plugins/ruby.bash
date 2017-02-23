#!/usr/bin/env bash

if ! hash ruby 2>/dev/null
then return
fi

export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
# GEM_PATH, BUNDLE_PATH
pathmunge "$GEM_HOME/bin" after
