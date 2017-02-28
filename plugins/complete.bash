#!/usr/bin/env bash

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [[ -e "$HOME/.ssh/config" ]]
then complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
fi

# Load system's Bash completion modules
if [[ -f /etc/bash_completion ]]
then source /etc/bash_completion
fi

# Some distribution makes use of a profile.d script to import completion.
if [[ -f /etc/profile.d/bash_completion.sh ]]
then source /etc/profile.d/bash_completion.sh
fi

# Load Hombrew bash completion modules
if [[ "$(uname)" = "Darwin" ]] && command -v brew &>/dev/null
then BREW_PREFIX=$(brew --prefix)
  if [[ -f "$BREW_PREFIX"/etc/bash_completion ]]
  then source "$BREW_PREFIX"/etc/bash_completion
  fi
  if [[ -f "$BREW_PREFIX"/share/bash-completion/bash_completion ]]
  then source "$BREW_PREFIX"/share/bash-completion/bash_completion
  fi
fi
