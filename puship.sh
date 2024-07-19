#!/bin/bash

usage() {
    cat<<EOF
NAME
    ${0} - Shares the WAN IP of the network gateway with a remote host.
EOF
}

set -o errexit

include(./utils.sh)dnl
include(./ip.sh)dnl


# compilation time constants
ssh=/usr/bin/ssh
proxy_edithosts_exe=/home/ppnoul/pubip/edithosts
proxy_edithosts_hostsfile=/home/ppnoul/pubip/etc/hosts
proxy_login_username=$USER
proxy_hostname=localhost
proxy_port=22
host_aliases=

main() {
    print "[$(date)] Attempting to push IP..."

    host_ip=$(ip_get_link_ip $(ip_get_wan_link))
    host_hostname=$(hostname)
    gateway_wan_ip=$(get_gateway_wan_ip)
    proxy=$(make_proxy_uri)
    command=$(make_edithosts_command)

    print "Will run -> ${command}"
    print "At host -> ${proxy}"

    set +o errexit
    $ssh $proxy 'ls'
    if (( $? > 0 )); then
        print 'Failed to update IP'
        exit 1
    else
        print 'Successfully updated IP'
    fi
}
make_proxy_uri() {
    echo "ssh://${proxy_login_username}@${proxy_hostname}:${proxy_port}"
}
make_edithosts_command() {
    echo "${proxy_edithosts_exe} \
         '${gateway_wan_ip}' '${host_hostname}' ${host_aliases:+'$host_aliases'} \
         --hostsfile='${proxy_edithosts_hostsfile}' \
         --host-syntax='ip+hostname' \
         --force" | sed -E 's/[[:space:]]{2,}/ /g'
}
main "$@"
