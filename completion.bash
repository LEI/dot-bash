#!/usr/bin/env bash

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [[ -e "$HOME/.ssh/config" ]]; then # [[ -d "$HOME/.ssh/config.d" ]]
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
fi

# Load system's Bash completion modules
source_prefix /etc/bash_completion

# Darwin only?
source_prefix /share/bash-completion/bash_completion

# Some distribution makes use of a profile.d script to import completion.
source_prefix /etc/profile.d/bash_completion.sh
