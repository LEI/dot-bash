#!/usr/bin/env bash

# https://github.com/mrzool/bash-sensible/blob/master/sensible.bash

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Automatically trim long paths in the prompt, requires ((BASH_VERSINFO[0] < 4))
#PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# # Perform file completion in a case insensitive fashion
# bind "set completion-ignore-case on"

# # Treat hyphens and underscores as equivalent
# bind "set completion-map-case on"

# # Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on"

# # Immediately add a trailing slash when autocompleting symlinks to directories
# bind "set mark-symlinked-directories on"
