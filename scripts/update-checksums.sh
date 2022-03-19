#!/usr/bin/env bash

readonly softs=( creds facron germinal gpaste )

update_checksums() {
    local soft="${1}"
    local hash

    pushd "${0%/*}/../files/${soft}" >/dev/null
    for hash in sha1 sha256 sha512; do
        ${hash}sum *tar* > ${hash}sum
    done
    popd >/dev/null
}

main() {
    local soft

    for soft in "${softs[@]}"; do
        update_checksums "${soft}"
    done
}

main "${@}"
