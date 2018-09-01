#!/usr/bin/env bash

if ! hash ruby 2>/dev/null; then
  return
fi

# gemdir="$(gem env gemdir)"
# gempath="$(gem env gempath)"

# gemdir: $HOME/.gem/ruby/X.X.X
userdir="$(ruby -e 'print Gem.user_dir')"

export GEM_HOME="$userdir"
# export GEM_PATH="$gempath:$GEM_HOME"
# OSX GEM PATHS:
#   - $HOME/.gem/ruby/2.5.0
#   - /usr/local/lib/ruby/gems/2.5.0
#   - /usr/local/Cellar/ruby/2.5.1/lib/ruby/gems/2.5.0

# BUNDLE_PATH

pathmunge "$GEM_HOME/bin" after
