#!/usr/bin/env bash

readonly softs=( creds facron germinal gpaste )

update_sha1() {
    local soft="${1}"

    pushd "${0%/*}/../files/${soft}" >/dev/null
    sha1sum "${soft}"* > sha1sum
    popd >/dev/null
}

main() {
    local soft

    for soft in "${softs[@]}"; do
        update_sha1 "${soft}"
    done
}

main "${@}"
