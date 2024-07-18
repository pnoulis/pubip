# the NetworkManager package installs multiple tools
# - nmcli
#   A command line interface to NetworkManager
# - nmtui
#   A terminal user interface to NetworkManager
#
# To understand how to add/modify a connection consult the manpages:
# - man 5 nmcli
#   Describes the syntax and options of nmcli
# - man 5 nm-settings-nmcli
#   Options to the various nmcli subcommands.
# - man 7 nmcli-examples
#   Examples
#
# Also check:
# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_ip_networking_with_nmcli

nm_create_static_wifi_conn() {
    local ssid="$1"
    local ifname=$2
    local address=$3
    local network_bits=$4
    local gateway=$5
    local dns=$6

    nmcli \
        --offline \
        connection add \
        type wifi \
        ifname $ifname \
        con-name default-wifi \
        ssid "$ssid" \
        connection.autoconnect yes \
        ipv4.method manual \
        ipv4.address ${address}/${network_bits} \
        ipv4.gateway $gateway \
        ipv4.dns $dns \
        wifi-sec.auth-alg open \
        wifi-sec.key-mgmt wpa-psk
}

nm_create_static_eth_conn() {
    local ifname=$1
    local address=$2
    local network_bits=$3
    local gateway=$4
    local dns=$5

    nmcli \
        --offline \
        connection add \
        type ethernet \
        ifname $ifname \
        con-name default-eth \
        connection.autoconnect yes \
        ipv4.method manual \
        ipv4.address ${address}/${network_bits} \
        ipv4.gateway $gateway \
        ipv4.dns $dns
}
