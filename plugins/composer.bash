#!/usr/bin/env bash

# PHP temp directory (/var/folders/x_/x/T) does not exist or is not writable to Composer. Set sys_temp_dir in your php.ini

if ! hash composer 2>/dev/null; then
  return
fi

# pathmunge "$(composer config -g home)/$(composer config -g bin-dir)" after
COMPOSER_HOME=~/.composer   # "$(composer config -g home 2>/dev/null)"
COMPOSER_BIN_DIR=vendor/bin # "$(composer config -g bin-dir 2>/dev/null)"

if [[ -d "$COMPOSER_HOME/$COMPOSER_BIN_DIR" ]]; then
  pathmunge "$COMPOSER_HOME/$COMPOSER_BIN_DIR" after
fi
