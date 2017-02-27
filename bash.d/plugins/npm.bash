#!/usr/bin/env bash

if ! hash npm 2>/dev/null
then return
fi

# if [[ -z "${NODE_MODULES_PATH-}" ]]; then
#   NODE_MODULES_PATH="$(npm config get prefix)"
# fi
# pathmunge "$NODE_MODULES_PATH" after
pathmunge "$HOME/.node_modules/bin" after
