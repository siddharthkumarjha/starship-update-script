#!/bin/bash
set -eu
printf '\n'

BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
UNDERLINE="$(tput smul 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
BLUE="$(tput setaf 4 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

info() {
  printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
}

completed() {
  printf '%s\n' "${GREEN}✓${NO_COLOR} $*"
}

verify_remote_error(){
    # info "function invoked ${1:+x}"
    if [ -z "${1:+x}" ]; then
        error "Couldn't receive version Info from remote server"
        error "Exiting..."
        exit 1
    else
        true
    fi
}

generate_version_info(){
    info "Contacting Remote Github Repo to fetch latest version of starship"
    local remote_version="$(curl -sSf https://api.github.com/repos/starship/starship/releases/latest | grep "tag_name" | cut -d : -f 2 | tr -d \",v)"
    verify_remote_error "${remote_version}"
    completed "We received remote version: ${remote_version}"
    local rem_maj="${remote_version%%.*}"
    local rem_min="${remote_version%.*}"
    rem_min="${rem_min#*.}"
    local rem_rev="${remote_version##*.}"

    # info "Thus Maj: ${rem_maj} Min: ${rem_min} Rev: ${rem_rev}"

    local local_version="$(starship --version | grep starship | cut -d " " -f 2)"
    
    info "Our local Version is: ${local_version}"
    
    local local_maj="${local_version%%.*}"
    local local_min="${local_version%.*}"
    local_min="${local_min#*.}"
    local local_rev="${local_version##*.}"

    # info "Thus Maj: ${local_maj} Min: ${local_min} Rev: ${local_rev}"
}
echo "Starting execution:"
generate_version_info
info "We received the following flags: $@"