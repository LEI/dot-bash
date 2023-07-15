#!/usr/bin/env bash

if ! hash kubectl 2>/dev/null; then
  return
fi

# alias k="kubectl"
alias ks="kubectl get all --all-namespaces"
alias kdn="kubectl describe node"
alias kso="ks -o=wide"

# Events
alias ke="kubectl get events --all-namespaces --sort-by=.lastTimestamp"

# Monitor resources
alias kn="kubectl top node"
alias knc="kubectl top node --show-capacity"
alias ku="kubectl top pod --all-namespaces --sum"

k() {
  if [ "$#" -eq 0 ]; then
    kubectl config get-contexts
  else
    kubectl "$@"
  fi
}
# https://kubernetes.io/docs/reference/kubectl/cheatsheet/#bash
if [ -f "/usr/share/bash-completion/completions/kubectl" ]; then
  source /usr/share/bash-completion/completions/kubectl
  complete -o default -F __start_kubectl k
fi
