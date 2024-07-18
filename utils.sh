print() {
    echo -e "${0}: $@"
}
debugv() {
    echo $1:"${!1}"
}
debug() {
    echo "$1":"$2"
}
fatal() {
    echo "$0:" "$@"
    exit 1
}
true() {
    if [[ "${!1}" == true ]] || [[ "${!1}" != false && "${!1}" != '' ]]; then
        return 0
    else
        return 1
    fi
}
false() {
    if [[ "${!1}" == false || "${!1}" == "" ]]; then
        return 0
    else
        return 1
    fi
}
parse_param() {
    _param=
    local param arg
    local -i toshift=0

    if (($# == 0)); then
        return $toshift
    elif [[ "$1" =~ .*=.* ]]; then
        param="${1%%=*}"
        arg="${1#*=}"
    elif [[ "${2-}" =~ ^[^-].+ ]]; then
        param="$1"
        arg="$2"
        ((toshift++))
    fi


    if [[ -z "${arg-}" && ! "${OPTIONAL-}" ]]; then
        fatal "${param:-$1} requires an argument"
    fi

    _param="${arg:-}"
    return $toshift
}
