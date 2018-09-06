#!/usr/bin/env bash

# c.f. ~/.exports

# CDPATH="."

export HISTSIZE=500000     # 32768
export HISTFILESIZE=100000 # "${HISTSIZE}"
export HISTCONTROL="erasedups:ignoreboth"
# export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT="%F %T "

# export LESS_TERMCAP_md="${yellow}"
# export MANPAGER="less -X"

# Disable shared history (~/.bash_sessions_disable)
# SHELL_SESSION_HISTORY=0

# Ctrl-D
# if [[ "$IGNOREEOF" -lt 10 ]]
# then export IGNOREEOF=10
# fi
