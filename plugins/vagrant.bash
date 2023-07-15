#!/usr/bin/env bash

if ! hash vagrant 2>/dev/null; then
  return
fi

alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vhalt="vagrant halt"
alias vsuspend="vagrant suspend"
alias vreload="vagrant reload --provision"
alias vclean="vagrant global-status --prune"
alias vstatus="vagrant status"
