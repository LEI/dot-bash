#!/usr/bin/env bash

# https://github.com/Bash-it/bash-it/blob/master/themes/colors.theme.bash

if tput setaf 1 &> /dev/null; then
  reset=$(tput sgr0)

  bold=$(tput bold)
  dim=$(tput dim)
  underline=$(tput smul)
  blink=$(tput blink)
  reverse=$(tput rev)
  standout=$(tput smso)

  reset_bold=$(tput sgr0)
  reset_dim="$(tput sgr0)"
  reset_underline=$(tput sgr0)
  reset_underline=$(tput rmul)
  reset_blink=$(tput sgr0)
  reset_standout=$(tput rmso)

  # restore=$(tput rmcup)

  black=$(tput setaf 0)
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  white=$(tput setaf 7)
  orange=$(tput setaf 166)
else
  reset="\[\e[0m\]"

  bold="\[\e[1m\]"
  dim="\[\e[2m\]"
  underline="\[\e[4m\]"
  blink="\[\e[5m\]"
  reverse="\[\e[7m\]"

  # reset_color="\[\e[39m\]" # Default foreground color
  reset_bold="\[\e[21m\]"
  reset_dim="\[\e[22m\]"
  reset_underline="\[\e[24m\]"
  reset_blink="\[\e[25m\]"
  reset_reverse="\[\e[27m\]"

  black="\[\e[0;30m\]"
  red="\[\e[0;31m\]"
  green="\[\e[0;32m\]"
  yellow="\[\e[0;33m\]"
  blue="\[\e[0;34m\]"
  magenta="\[\e[0;35m\]"
  cyan="\[\e[0;36m\]"
  white="\[\e[0;37m\]"
  orange="\[\e[0;91m\]"
fi
