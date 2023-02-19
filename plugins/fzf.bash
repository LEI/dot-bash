#!/usr/bin/env bash

if ! hash fzf 2>/dev/null && [[ ! -d ~/.fzf ]]; then
  return
fi

for dir in {/usr/local/opt/fzf,~/.config/fzf,~/.fzf}; do
  if [[ $dir == "$HOME/.fzf" ]] && [[ -d "$dir/bin" ]]; then
    pathmunge "$dir/bin" after
  fi
  if [[ -d "$dir/shell" ]]; then
    source "$dir/shell/key-bindings.bash"
    source "$dir/shell/completion.bash"
    break
  fi
done

if hash ag 2>/dev/null; then
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""' # --nocolor
else
  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD ||
    find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
fi

# https://github.com/helix-editor/helix/issues/196#issuecomment-1412493924
# export FZF_DEFAULT_OPTS='... ,ctrl-o:execute(hx $(echo {} | cut -d ":" -f1))'
if hash rg 2>/dev/null; then
  fzf_search() {
    local editor=hx # "${VISUAL:-${EDITOR}}"
    local batcat="bat"
    # Search using rg and fzf with preview
    local out=$(rg . --line-number --column --no-heading --glob '!.git' |
      fzf +i --exact --delimiter : --preview "$batcat --style=full --color=always --highlight-line {2} {1}" --preview-window 'up,~4,+{2}+4/2')

    # Remove cruft leaving something like: 'file:line:column'
    # echo "$out" | sed -E 's/([a-zA-Z0-9/-_]*):([0-9]*):([0-9]*):.*/\1:\2:\3/'
    $editor "$(echo $out | cut -d: -f1)"
  }
fi

export FZF_DEFAULT_OPTS='' # --height 40% --reverse --border
# --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
# --color info:108,prompt:109,spinner:108,pointer:168,marker:168

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# https://github.com/junegunn/fzf/wiki/Color-schemes
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "

  # Solarized Light color scheme for fzf
  # export FZF_DEFAULT_OPTS="
  #   --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
  #   --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  # "
}
# _gen_fzf_default_opts
