#!/usr/bin/env bash
# shellcheck disable=SC2046,SC2086

# https://github.com/wsargent/docker-cheat-sheet

if ! hash docker 2>/dev/null; then
  return
fi

# TODO check alias d=?

d() {
  local cmd="$1"
  shift
  local last_id="docker ps --latest --quiet"
  case "$cmd" in
    '' | a | pa | psa) docker ps --all ;; # List all containers
    *-all) d_all "${cmd%-all}" "$@" ;;
    b) docker build -t "$1" "${2:-.}" "${@:3}" ;;
    bash | sh) d_exec "${1:-$($last_id)}" "$cmd" "${@:2}" ;;
    c | compose) d_compose "$@" ;;
    clean) d_clean "$@" ;;
    dangling) docker images --all --quiet --filter "dangling=${1:-true}" "${@:2}" ;;
    e) d_exec "${1:-$($last_id)}" "$2" "${@:3}" ;;
    e:*) d_exec "${1:-$($last_id)}" "${cmd#e:}" "${@:2}" ;;
    env) d_env "$@" ;; # env | grep DOCKER_
    i | img) docker images "$@" ;; # --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.CreatedSince}}\t{{.Size}}"
    id) docker ps --all --quiet --filter "name=$1" "${@:2}" ;;
    ip) d_ip "${1:-$($last_id)}" "${@:2}" ;;
    l) docker logs --follow --timestamps "$@" ;; # --since, --tail=all
    last) $last_id "$@" ;; # Latest container ID (ps -lq)
    m | machine) d_machine "$@" ;;
    p) docker pull "$@" ;; # --all-tags
    r) d_run "$@" ;; # "$c" "${2:-/app}" "${3:-$PWD}"
    *) docker "$cmd" "$@" ;;
  esac
}

d_all() {
  local cmd="$1"
  shift
  case "$cmd" in
    '' | ps) docker ps --all "$@" ;;
    rmi) docker rmi $(docker images --quiet) "$@" ;;
    rm | start | stop | *) docker "$cmd" $(docker ps --all --quiet) "$@" ;;
  esac
}

# docker-cleanup
# https://github.com/spotify/docker-gc
d_clean() {
  local cmd="$1"
  local dangling=
  shift
  case "$cmd" in # d i | awk '/<none>/ {print $3}/'
    '' | i | images)
      dangling="$(d dangling)"
      if [[ -n "$dangling" ]]; then docker rmi $dangling "$@"; fi
      ;;
    # created) docker rm $(docker ps --all | awk '/Created \([0-9]+\)/ {print $1}') ;;
    exited) docker rm $(docker ps --all | awk '/Exited \([0-9]+\)/ {print $1}') ;;
    *) return 1 ;;
  esac
}

d_env() {
  if [[ $# -ne 0 ]]; then
    d_machine env "$@"
  else
    local v
    for v in "${!DOCKER_@}"; do
      printf "%s=\"%s\"\n" "$v" "${!v}"
    done
  fi
}

d_exec() {
  # local c="$(d id "$1" || docker ps -lq)"
  [[ -n "$1" ]] && docker exec --interactive --tty \
    "$1" "${2:-bash}" "${@:3}"
}

d_ip() {
  [[ -n "$1" ]] && docker inspect \
    --format "{{.NetworkSettings.IPAddress}}" \
    "$1" "${@:2}"
}

d_compose() {
  # hash docker-compose 2>/dev/null || return 1
  local cmd="$1"
  shift
  case "$cmd" in
    '') docker-compose ps "$@" ;;
    b) docker-compose build "$@" ;;
    l) docker-compose logs --follow --timestamps "$@" ;; # --tail=all
    r) docker-compose run "$@" ;;
    u) docker-compose up -d "$@" ;; # --{force,no}-recreate --{,no-}build
    *) docker-compose "$cmd" "$@" ;;
  esac
}

d_machine() {
  # hash docker-machine 2>/dev/null || return 1
  local cmd="$1"
  shift
  case "$cmd" in
    '') docker-machine ls "$@" ;;
    c) docker-machine create --driver "${1:-virtualbox}" "${@:2}" ;;
    e) docker-machine env "$@" ;;
    eval) eval "$(docker-machine env "${1:-default}")" "${@:2}" ;;
    rs) docker-machine restart "$@" ;; # one or more machine names
    s) docker-machine status "$@" ;; # machine name
    *) docker-machine "$cmd" "$@" ;;
  esac
}

# Deamonized: docker run -d -P <img> <cmd>
# Interactive: docker run -i -t -P <img> <cmd>

# d_run <img> <vol> [<dir>] [args..]
d_run() {
  local i="$1" # Image
  shift
  local v="${1:-/app}"
  shift
  local d="${1:-$(pwd)}"
  shift
  [[ -n "$i" ]] && [[ -n "$v" ]] &&
    docker run \
      --interactive --tty --rm \
      --volume "$d:$v" \
      --workdir "$v" \
      "$i" "$@"
  # --name "${1:-${v##*/}}"
  # --user $(id -u):$(id -g)
  # --publish 80:80
}

if hash _docker 2>/dev/null; then
  complete -F _docker d
fi

if hash _docker-compose 2>/dev/null; then
  complete -F _docker-machine d_compose
fi

if hash _docker-machine 2>/dev/null; then
  complete -F _docker-machine d_machine
fi
