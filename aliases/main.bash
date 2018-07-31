#!/usr/bin/env bash

# Enable aliases even if not interactive
shopt -s expand_aliases

alias sudo="sudo "

# alias df="df -ah" # -T --total # pydf
# alias du="du -ach | sort -h" # ncdu
alias cp="cp -v"
alias ln="ln -v"
alias mv="mv -v"
alias rm="rm -v"
alias wget="wget -c"

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias h="history"
alias hgrep="history | grep"
alias j="jobs"
alias l="ls -lF"
alias la="ls -lAF"
alias rd="rmdir"

alias ipecho="curl ipecho.net/plain; echo"
alias map="xargs -n1"
alias urlencode="python -c 'import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);'"

alias path='echo $PATH | tr -s ":" "\n"'
alias reload="source ~/.bashrc"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

for method in GET HEAD POST PUT DELETE TRACE OPTIONS
do alias $method="lwp-request -m '$method'"
done
unset method