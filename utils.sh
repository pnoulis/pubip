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
