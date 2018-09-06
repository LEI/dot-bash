#!/usr/bin/env bash

__prompt_command() {
  local exit=$?

  if [[ "$exit" -eq 0 ]]; then
    EXIT_COLOR=""
  else
    EXIT_COLOR="${red}"
  fi

  # # Record each line as it gets issued
  # history -a
}

__prompt_right() {
  local width

  if [[ -n "$COLUMNS" ]]; then
    width="$COLUMNS"
  else
    width="$(tput cols)"
  fi

  printf "%*s\r" "$width" "$1"
}

__prompt_string() {
  local prompt_symbol="${1:-\$ }"
  local p

  p='\n'

  # Update the terminal title
  # Tmux? \033k\w\033\\
  # OSC title? \033]2;\w\033\\
  # p+='\[\033]0;\w\007\]'
  p+='\[\e]2;\w\a\]'

  # Right align the time
  # p+='\[$(tput sc; __prompt_right "\t"; tput rc)\]'

  # printf "%*(%T)T\r" "$width"
  # p+='\[$(tput sc; printf "%*s\r" "$width" "$(date +%T)"; tput rc)\]'
  # p+='\[$(tput sc; printf "%*s" "$width" "\t"; tput rc)\]'

  p+='\[${reset}\]'
  # Highlight the user when logged in as root
  if [[ "${USER}" == "root" ]]; then
    p+='\[${red}\]'
  else
    p+='\[${blue}\]'
  fi
  p+='\u'
  p+='\[${reset}\]'

  # Display the host only if different of the user
  if [[ "${USER}" != "${HOSTNAME%%.*}" ]]; then
    p+=' '
    p+='\[${dim}\]'
    p+='at'
    p+='\[${reset}\]'
    p+=' '
    # Highlight when connected via SSH
    if [[ -n "${SSH_TTY}" ]]; then
      p+='\[${red}\]'
    else
      p+='\[${cyan}\]'
    fi
    p+='\h'
    p+='\[${reset}\]'
  fi

  # Working directory
  p+=' '
  p+='\[${dim}\]'
  p+='in'
  p+='\[${reset}\]'
  p+=' '
  # p+='\[${bold}\]'
  p+='\[${bright_blue}\]' # white
  p+='\w'
  p+='\[${reset}\]'

  # Git status
  p+='$(__prompt_git "\[${dim}\] on \[${reset}\]%s%s")'

  p+='\n'

  p+='\[${EXIT_COLOR}\]'
  p+="$prompt_symbol"
  p+='\[${reset}\]'

  printf "%s" "$p"
}

__prompt_git() {
  local exit=$?
  local repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
    --is-bare-repository --is-inside-work-tree \
    --short HEAD 2>/dev/null)"
  local rev_parse_exit="$?"
  if [[ -z "$repo_info" ]]; then
    return $exit
  fi
  local short_sha="${repo_info##*$'\n'}"

  local line=
  local branch_info=
  local count=0
  while IFS= read -r -d '' line; do
    case "${line:0:2}" in
      \#\#) branch_info="${line#\#\# }" ;;
      *) ((count++)) ;;
      # ?M) ((changed++)) ;;
      # ?A) ((added++)) ;;
      # ?D) ((deleted++)) ;;
      # U?) ((updated++)) ;;
      # \?\?) ((untracked++)) ;;
      # *) ((staged++)) ;;
    esac
  done < <(git status -z --porcelain --branch) 2>/dev/null

  local behind ahead
  local pattern=
  local var=
  for var in {ahead,behind}; do
    ## [ahead x, behind y]
    pattern='(\[|[[:space:]])'${var}'[[:space:]]+([[:digit:]])(,|\])'
    if [[ "$branch_info" =~ $pattern ]]; then
      if [[ "${#BASH_REMATCH[@]}" -ge 2 ]]; then
        # ${!var}="${BASH_REMATCH[2]}"
        declare "${var}"="${BASH_REMATCH[2]}"
      fi
    fi
  done

  local diff=
  local head_no_branch=""
  [[ -n "$behind" ]] && diff+="<"
  [[ -n "$ahead" ]] && diff+=">"
  local branch=
  ## master...origin/master
  if [[ "$branch_info" =~ \.\.\. ]]; then
    branch="${branch_info%\.\.\.*}"
    branch="${branch##* }"
  elif [[ "$branch_info" == "HEAD (no branch)" ]]; then
    branch="$short_sha"
  else
    branch="$branch_info"
  fi

  local flag=
  local flag_color="bright_blue"
  local branch_color=
  if [[ "$count" -gt 0 ]]; then
    flag="*"
    if [[ "$branch" == "master" ]]; then
      branch_color="red"
    else
      branch_color="orange"
    fi
  elif [[ -n "$ahead" ]] || [[ -n "$behind" ]]; then
    branch_color="yellow"
  else
    branch_color="green"
  fi

  local printf_format="${1:- on %s%s}"
  printf -- "${printf_format}" "${!branch_color}$branch${reset}" "${!flag_color}$flag${reset}$diff"
}
