#!/usr/bin/env bash

__prompt_command() {
  local exit=$?

  # EXIT_CODE=$exit
  EXIT_COLOR=
  if [[ "$exit" -ne 0 ]]; then
    EXIT_COLOR="${red}"
  fi

  PROMPT_SYMBOL="${1:-${PROMPT_SYMBOL:-\$}}"
  if [[ "$UID" -eq 0 ]]; then
    PROMPT_SYMBOL="\$" # \#
  fi

  # GIT_STATUS_PORCELAIN="$(__prompt_git)"

  # # Right align prompt
  # # https://superuser.com/a/1203400/724216
  # PS1R=
  # if hash porcelain 2>/dev/null; then
  #   PS1R+="$(porcelain '\[${red}\]%s\[${reset}\]' '\[${yellow}\]%s\[${reset}\]' '\[${green}\]%s\[${reset}\]')"
  #   # PS1R+="$(porcelain)"
  # fi
  # if [[ -n "$PS1R" ]]; then
  #   # Strip ANSI commands before counting length
  #   PS1R_stripped=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$PS1R")
  # fi

  # # Record each line as it gets issued
  # history -a
}

__prompt_right() {
  local width
  width="${COLUMNS:-$(tput cols)}"
  printf "%*s\r" "$width" "$1"
}

__prompt_string() {
  local p

  # p='\n'

  # # Reference: https://en.wikipedia.org/wiki/ANSI_escape_code
  # # '\e[s' # Save cursor position
  # # '\e[u' # Restore cursor to save point
  # p='\[\e[s\e[${COLUMNS:-$(tput cols)}C\e[${#PS1R_stripped}D${PS1R}\e[u\]'
  # # p='\[$(tput sc; printf "%*s\r" "${COLUMNS:-$(tput cols)}" "$PS1R"; tput rc)\]'

  # Update the terminal title
  # Tmux? \033k\w\033\\
  # OSC title? \033]2;\w\033\\
  # p+='\[\033]0;\w\007\]'
  p+='\[\e]2;\w\a\]'

  # # Right align prompt
  # if hash porcelain; then
  #   git_status='$(porcelain "\[${red}\]%s\[${reset}\]" "\[${yellow}\]%s\[${reset}\]" "\[${green}\]%s\[${reset}\]")'
  #   p+='\[$(tput sc; __prompt_right '"$git_status"'; tput rc)\]'
  # fi

  # printf "%*(%T)T\r" "$width"
  # p+='\[$(tput sc; printf "%*s\r" "$width" "$(date +%T)"; tput rc)\]'
  # p+='\[$(tput sc; printf "%*s" "$width" "\t"; tput rc)\]'

  p+='\[${reset}\]'
  # # Highlight the user when logged in as root
  # if [[ "${USER}" == "root" ]]; then
  #   p+='\[${red}\]'
  # else
  #   p+='\[${blue}\]'
  # fi
  # p+='\u'
  # p+='\[${reset}\]'

  # # Display the host only if different of the user
  # if [[ "${USER}" != "${HOSTNAME%%.*}" ]]; then
  #   p+=' '
  #   p+='\[${dim}\]'
  #   p+='at'
  #   p+='\[${reset}\]'
  #   p+=' '
  #   # Highlight when connected via SSH
  #   if [[ -n "${SSH_TTY}" ]]; then
  #     p+='\[${red}\]'
  #   else
  #     p+='\[${cyan}\]'
  #   fi
  #   p+='\h'
  #   p+='\[${reset}\]'
  # fi
  if [[ -n "$SSH_TTY" ]]; then
    p+='\[${red}\]'
    p+='\h'
    p+='\[${reset}\]'
    p+=' '
  fi

  # Working directory
  # p+=' '
  # p+='\[${dim}\]'
  # p+='in'
  # p+='\[${reset}\]'
  # p+=' '
  # # p+='\[${bold}\]'
  p+='\[${bright_blue}\]' # white
  p+='\w'
  p+='\[${reset}\]'

  # Git status
  # p+='$(__prompt_git "\[${dim}\] on \[${reset}\]%s%s")'
  p+='$(__prompt_git)'
  # p+='$GIT_STATUS_PORCELAIN'

  # p+='\n'
  p+=' '

  p+='\[${EXIT_COLOR}\]'
  p+='${PROMPT_SYMBOL} '
  p+='\[${reset}\]'

  printf "%s" "$p"
}

__prompt_git() {
  if hash porcelain 2>/dev/null; then
    # porcelain " \[${red}\]%s\[${reset}\]" " \[${yellow}\]%s\[${reset}\]" " \[${green}\]%s\[${reset}\]"
    porcelain " ${red}%s${reset}" " ${yellow}%s${reset}" " ${green}%s${reset}"
  fi

  # local exit=$?
  # local repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
  #   --is-bare-repository --is-inside-work-tree \
  #   --short HEAD 2>/dev/null)"
  # local rev_parse_exit="$?"
  # if [[ -z "$repo_info" ]]; then
  #   return $exit
  # fi
  # local short_sha="${repo_info##*$'\n'}"

  # local line=
  # local branch_info=
  # local count=0
  # while IFS= read -r -d '' line; do
  #   case "${line:0:2}" in
  #     \#\#) branch_info="${line#\#\# }" ;;
  #     *) ((count++)) ;;
  #     # ?M) ((changed++)) ;;
  #     # ?A) ((added++)) ;;
  #     # ?D) ((deleted++)) ;;
  #     # U?) ((updated++)) ;;
  #     # \?\?) ((untracked++)) ;;
  #     # *) ((staged++)) ;;
  #   esac
  # done < <(git status -z --porcelain --branch) 2>/dev/null

  # local behind ahead
  # local pattern=
  # local var=
  # for var in {ahead,behind}; do
  #   ## [ahead x, behind y]
  #   pattern='(\[|[[:space:]])'${var}'[[:space:]]+([[:digit:]])(,|\])'
  #   if [[ "$branch_info" =~ $pattern ]]; then
  #     if [[ "${#BASH_REMATCH[@]}" -ge 2 ]]; then
  #       # ${!var}="${BASH_REMATCH[2]}"
  #       declare "${var}"="${BASH_REMATCH[2]}"
  #     fi
  #   fi
  # done

  # local diff=
  # local head_no_branch=""
  # [[ -n "$behind" ]] && diff+="<"
  # [[ -n "$ahead" ]] && diff+=">"
  # local branch=
  # ## master...origin/master
  # if [[ "$branch_info" =~ \.\.\. ]]; then
  #   branch="${branch_info%\.\.\.*}"
  #   branch="${branch##* }"
  # elif [[ "$branch_info" == "HEAD (no branch)" ]]; then
  #   branch="$short_sha"
  # else
  #   branch="$branch_info"
  # fi

  # local flag=
  # local flag_color="bright_blue"
  # local branch_color=
  # if [[ "$count" -gt 0 ]]; then
  #   flag="*"
  #   if [[ "$branch" == "master" ]]; then
  #     branch_color="red"
  #   else
  #     branch_color="orange"
  #   fi
  # elif [[ -n "$ahead" ]] || [[ -n "$behind" ]]; then
  #   branch_color="yellow"
  # else
  #   branch_color="green"
  # fi

  # local printf_format="${1:- on %s%s}"
  # printf -- "${printf_format}" "${!branch_color}$branch${reset}" "${!flag_color}$flag${reset}$diff"
}
