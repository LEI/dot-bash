#!/usr/bin/env bash

# Enable aliases even if not interactive
shopt -s expand_aliases

alias reloadrc="source ~/.bashrc"

alias sudo="sudo "

alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias cp="cp -i"     # confirm before overwriting something
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
alias la="ls -lah"   # show all files with human-readable sizes
alias more=less
