#!/usr/bin/env bash

if ! hash npm 2>/dev/null; then
  return
fi

# https://docs.npmjs.com/getting-started/fixing-npm-permissions

# https://wiki.archlinux.org/index.php/Node.js#Allow_user-wide_installations
#export npm_config_prefix=~/.node_modules # "$HOME/.node_modules"

# if [[ -z "${NODE_MODULES_PATH-}" ]]; then
#   NODE_MODULES_PATH="$(npm config get prefix)"
# fi

#pathmunge "$npm_config_prefix/bin" after
pathmunge "$HOME/.node_modules/bin" after
