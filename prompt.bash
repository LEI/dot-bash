#!/usr/bin/env bash

# PROMPT_COMMAND invoked before rendering prompt string
# $1: non-privileged prompt symbol
# $2: line continuation prompt symbol
__prompt_command() {
  local exit=$?

  PS1_SYMBOL="${1:-${PROMPT_SYMBOL:-\$}}"
  PS2_SYMBOL="${2:-${PROMPT2_SYMBOL:-${PROMPT_SYMBOL:->}}}"
  if [[ "$UID" -eq 0 ]]; then
    PS1_SYMBOL='\$' # \#
  fi

  # EXIT_CODE=$exit
  EXIT_COLOR=
  if [[ "$exit" -ne 0 ]]; then
    EXIT_COLOR="$red"
  fi

  # GIT_STATUS_PORCELAIN="$(__prompt_git)"

  # # Right align prompt
  # # https://superuser.com/a/1203400/724216
  # PS1R="\e[0m[ \e[0;1;31m%(%b %d %H:%M)T \e[0m]" # '\w'
  # # if hash porcelain 2>/dev/null; then
  # #   PS1R+="$(porcelain '\[${red}\]%s\[${reset}\]' '\[${yellow}\]%s\[${reset}\]' '\[${green}\]%s\[${reset}\]')"
  # #   # PS1R+="$(porcelain)"
  # # fi
  # PS1R_stripped=
  # if [[ -n "$PS1R" ]]; then
  #   # Strip ANSI commands before counting length
  #   PS1R_stripped="$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$PS1R")"
  # fi

  # # Record each line as it gets issued
  # history -a
}

__prompt_right() {
  local width
  width="${COLUMNS:-$(tput cols)}"
  printf "%*s\r" "$width" "$1"
}

# shellcheck disable=SC2016
__set_prompt_string() {
  [[ -n "$1" ]] && PROMPT_SYMBOL="$1"
  [[ -n "$2" ]] && PROMPT2_SYMBOL="$2"
  local ps=

  # ps+='\n'

  # Reference: https://en.wikipedia.org/wiki/ANSI_escape_code
  # '\e[s' # Save cursor position
  # '\e[u' # Restore cursor to save point

  #ps+='\[\e[s\e[${COLUMNS:-$(tput cols)}C\e[${#PS1R_stripped}D${PS1R}\e[u\]'
  # ps+='\[$(tput sc; printf "%*s\r" "${COLUMNS:-$(tput cols)}" "$PS1R"; tput rc)\]'

  # Update the terminal title
  # Tmux? \033k\w\033\\
  # OSC title? \033]2;\w\033\\
  # ps+='\[\033]0;\w\007\]'
  ps+='\[\e]2;\w\a\]'

  # # Right align prompt
  # if hash porcelain; then
  #   git_status='$(porcelain "\[${red}\]%s\[${reset}\]" "\[${yellow}\]%s\[${reset}\]" "\[${green}\]%s\[${reset}\]")'
  #   ps+='\[$(tput sc; __prompt_right '"$git_status"'; tput rc)\]'
  # fi

  # printf "%*(%T)T\r" "$width"
  # ps+='\[$(tput sc; printf "%*s\r" "$width" "$(date +%T)"; tput rc)\]'
  # ps+='\[$(tput sc; printf "%*s" "$width" "\t"; tput rc)\]'

  ps+='\[${reset}\]'

  # Display the host only if different of the user
  # if [[ "${USER}" != "${HOSTNAME%%.*}" ]]; then
  # fi

  # Display the user when connected via SSH
  # and highlight in red if logged in as root
  if [[ -n "$SSH_TTY" ]] || [[ "$UID" -eq 0 ]]; then
    if [[ "$UID" -eq 0 ]]; then
      ps+='\[${red}\]'
    fi
    ps+='\u'
    ps+='\[${reset}\]'
    if [[ -n "$SSH_TTY" ]]; then
      ps+='\[${dim}\]@\[${reset}\]'
    else
      ps+=' '
    fi
  fi

  # Display the host when connected via SSH
  if [[ -n "$SSH_TTY" ]]; then
    ps+='\[${dim}\]'
    ps+='\h'
    ps+='\[${reset}\]'
    ps+=' '
  fi

  ps+='\[${bright_blue}\]' # white
  ps+='\w'
  ps+='\[${reset}\]'

  # Git status
  # ps+='$(__prompt_git "\[${dim}\] on \[${reset}\]%s%s")'
  #ps+='$(__prompt_git)'
  ps+='$(hash porcelain 2>/dev/null && porcelain " \[${red}\]%s\[${reset}\]" " \[${yellow}\]%s\[${reset}\]" " \[${green}\]%s\[${reset}\]")'
  # ps+='$GIT_STATUS_PORCELAIN'

  # ps+='\n'
  ps+=' '

  ps+='\[${EXIT_COLOR}\]'
  ps+='$PS1_SYMBOL' #ps+='$(printf "${PROMPT_SYMBOL_FORMAT}" "${PROMPT_SYMBOL}")'
  ps+='\[${reset}\]'

  PROMPT="${ps} " # printf "%s" "$ps"
  PROMPT2='${PS2_SYMBOL} '
}

# __prompt_git() {
#   local exit=$?
#   local repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
#     --is-bare-repository --is-inside-work-tree \
#     --short HEAD 2>/dev/null)"
#   local rev_parse_exit="$?"
#   if [[ -z "$repo_info" ]]; then
#     return $exit
#   fi
#   local short_sha="${repo_info##*$'\n'}"
#
#   local line=
#   local branch_info=
#   local count=0
#   while IFS= read -r -d '' line; do
#     case "${line:0:2}" in
#       \#\#) branch_info="${line#\#\# }" ;;
#       *) ((count++)) ;;
#       # ?M) ((changed++)) ;;
#       # ?A) ((added++)) ;;
#       # ?D) ((deleted++)) ;;
#       # U?) ((updated++)) ;;
#       # \?\?) ((untracked++)) ;;
#       # *) ((staged++)) ;;
#     esac
#   done < <(git status -z --porcelain --branch) 2>/dev/null
#
#   local behind ahead
#   local pattern=
#   local var=
#   for var in {ahead,behind}; do
#     ## [ahead x, behind y]
#     pattern='(\[|[[:space:]])'${var}'[[:space:]]+([[:digit:]])(,|\])'
#     if [[ "$branch_info" =~ $pattern ]]; then
#       if [[ "${#BASH_REMATCH[@]}" -ge 2 ]]; then
#         # ${!var}="${BASH_REMATCH[2]}"
#         declare "${var}"="${BASH_REMATCH[2]}"
#       fi
#     fi
#   done
#
#   local diff=
#   local head_no_branch=""
#   [[ -n "$behind" ]] && diff+="<"
#   [[ -n "$ahead" ]] && diff+=">"
#   local branch=
#   ## master...origin/master
#   if [[ "$branch_info" =~ \.\.\. ]]; then
#     branch="${branch_info%\.\.\.*}"
#     branch="${branch##* }"
#   elif [[ "$branch_info" == "HEAD (no branch)" ]]; then
#     branch="$short_sha"
#   else
#     branch="$branch_info"
#   fi
#
#   local flag=
#   local flag_color="bright_blue"
#   local branch_color=
#   if [[ "$count" -gt 0 ]]; then
#     flag="*"
#     if [[ "$branch" == "master" ]]; then
#       branch_color="red"
#     else
#       branch_color="orange"
#     fi
#   elif [[ -n "$ahead" ]] || [[ -n "$behind" ]]; then
#     branch_color="yellow"
#   else
#     branch_color="green"
#   fi
#
#   local printf_format="${1:- on %s%s}"
#   printf -- "${printf_format}" "${!branch_color}$branch${reset}" "${!flag_color}$flag${reset}$diff"
# }
