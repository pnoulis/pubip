#!/bin/bash

usage() {
    cat<<EOF
NAME
    ${0} - Appends a new host into hostsfile (by default /etc/hosts)

SYNOPSIS
    ${0} {IP_address} {canonical_hostname} [aliases...]

    --hostsfile <hostsfile>, --hostsfile=<hostsfile>
      Specify a different hostsfile other than /etc/hosts to append the
      HOST at.

    -f, --force
      If the HOST to be appended already exists, this forces the program
      to replace all existing instances with the new HOST.

    --host-syntax, --host-syntax=[ip | hostname | ip+hostname]
      Describes what constitutes a HOST.
      In the case of /ip/ the matching host pattern includes only IP_address.
      In the case of /hostname/ the pattern includes only canonical_hostname
      In the case of /ip+hostname/ the partern includes both IP_address and canonical_hostname

    -N, --dry-run
      Does not modify the hostsfile, instead write to stdout

DESCRIPTION
    ${0} appends a new line representing a HOST in the specified hosts
    file. The syntax of a HOST is described in '$(man 5 hosts)'.

SEE ALSO
    hosts(5), hostname(1), hostname(7)
EOF
}

include(./utils.sh)dnl

# bash
set -o errexit

# Options
hostsfile=/etc/hosts
host_syntax=ip+hostname
force=false
dryrun=false
debug=false

# Constants
AUTO_MSG="${0}: AUTO UPDATE ->"
SED=/usr/bin/sed
GREP=/usr/bin/grep

main() {
    parse_args "$@" >/dev/stdout
    set -- "${POSARGS[@]}"

    local ip=$1
    local hostname=$2
    local aliases=${@:3}
    host=
    make_host

    debugv hostsfile
    debugv ip
    debugv hostname
    debugv aliases
    debugv host

    false ip && fatal "Missing 1st argument -> IP_address"
    false hostname && fatal "Missing 2nd argument -> canonical_hostname"
    [[ ! -f "${hostsfile:-}" ]] && fatal "Missing hosts file -> '${hostsfile}'"

    print "Attempting to update ${hostsfile}"
    tmpfile=$(mktemp)
    cat "$hostsfile" > $tmpfile
    real_hostsfile="$hostsfile"
    hostsfile=$tmpfile

    if host_exists "$hostsfile"; then
        print "Host already exists -> ${host}"
        false force && exit 0
        delete_host
        add_host
    else
        add_host
    fi

    if true dryrun; then
        cat "$hostsfile" | sed -zE 's/\n{2,}/\n/gi'
    else
        cat "$hostsfile" | sed -zE 's/\n{2,}/\n/gi' > "$real_hostsfile"
    fi
    return 0
}

make_host() {
    case "$host_syntax" in
        ip)
            host="${ip}"
            ;;
        hostname)
            host="${hostname}"
            ;;
        ip+hostname)
            host="${ip} ${hostname}"
            ;;
        *)
            fatal "Unrecognized host syntax -> '${host_syntax}'"
    esac
}
host_exists() {
    $GREP --quiet "${host}" "$hostsfile"
}

add_host() {
    print "Adding new host -> ${ip} ${hostname} ${aliases}"
    echo -e "\n# ${AUTO_MSG} $(date --iso-8601=seconds)\n${ip} ${hostname}${aliases:+ $aliases}" >> "$hostsfile"
}

delete_host() {
    local _tmpfile=$(mktemp)
    local host_detected=false
    while read -r line; do
        if [[ "$line" =~ .*$host ]]; then
            print "Deleting host -> ${line}"
            host_detected=true
            continue
        elif true host_detected; then
            host_detected=false
            if [[ "$line" =~ .*$AUTO_MSG.* ]]; then
                continue
            fi
        fi
        echo "$line" >> $_tmpfile
    done < <(tac "$hostsfile")
    tac $_tmpfile > $tmpfile
    rm $_tmpfile
    return 0
}

parse_args() {
    declare -ga POSARGS=()
    _param=
    while (($# > 0)); do
        case "${1:-}" in
            --hostsfile | --hostsfile=*)
                parse_param "$@" || shift $?
                eval hostsfile="$_param"
                ;;
            -f | --force)
                force=true
                ;;
            --host-syntax | --host-syntax=*)
                parse_param "$@" || shift $?
                host_syntax="$_param"
                ;;
            -D | --debug)
                debug=true
                ;;
            -N | --dry-run)
                dryrun=true
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            -v | --version)
                echo $VERSION
                ;;
            -[a-zA-Z][a-zA-Z]*)
                local i="${1:-}"
                shift
                local rest="$@"
                set --
                for i in $(echo "$i" | grep -o '[a-zA-Z]'); do
                    set -- "$@" "-$i"
                done
                set -- $@ $rest
                continue
                ;;
            --)
                shift
                POSARGS+=("$@")
                ;;
            -[a-zA-Z]* | --[a-zA-Z]*)
                fatal "Unrecognized argument ${1:-}"
                ;;
            *)
                POSARGS+=("${1:-}")
                ;;
        esac
        shift
    done
}

main "$@"
