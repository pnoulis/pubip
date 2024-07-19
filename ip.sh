# The command `ip route get <IP>` is used to find out the network
# interface device that will be called to handle the connection to the
# requested <IP>.
#
# As such, if the IP provided references a WAN IP and not the origin
# Host the found device shall be the one responsible for handling WAN
# bound traffic.
#
# Hence, the task of *accurately* or *definitively* getting a hold of
# the name of the "active" (more than 1 interface may be active, but
# only one handles WAN bound traffic at any one time; I guess..)
# network interface can be achieved through this method.
ip_get_wan_link() {
    local random_wan_ip=1.1.1.1
    ip -json route get $random_wan_ip | jq -r '.[].dev'
}
ip_get_link_ip() {
    local link=$1
    ip -json -details address show $link \
        | jq -r '.[].addr_info[] | select(.family=="inet") | .local'
}

# Get the amount of bits which are allocated to the network. I will
# refer to them as network_bits. The network_bits can then be used to
# determine the netmask.
#
# @param {string} network interface device - referred throughout as link
# @returns {number} network_bits
ip_get_link_network_bits() {
    local link=$1
    ip -json -details address show $link \
        | jq -r '.[].addr_info[] | select(.family=="inet") | .prefixlen'
}

# Translate network bits to a netmask.
#
# @param {number} bits
# @returns {string} netmask
bits_to_netmask() {
    local bits=$1
    local netmask=
    case $bits in
        24) # class C network
            netmask=255.255.255.0
            ;;
        16) # class B network
            netmask=255.255.0.0
            ;;
        8) # class A network
            netmask=255.0.0.0
            ;;
        *)
            echo "Unsupported network bits '$bits'"
    esac
    echo $netmask
}
ip_get_link_broadcast() {
    local link=$1
    ip -json -details address show $link \
        | jq -r '.[].addr_info[] | select(.family=="inet") | .broadcast'
}
ip_get_link_gateway_ip() {
    local link=$1
    ip -json route \
        | jq -r --arg link $link '.[] | select(.dev==$link) | select(.dst=="default") | .gateway'
}
ip_get_link_dns() {
    local link=$1
    # assume that the DNS server is hosted by the default gateway of the links default gateway
    local link=$1
    ip -json route \
        | jq -r --arg link $link '.[] | select(.dev==$link) | select(.dst=="default") | .gateway'
}
get_gateway_wan_ip() {
    printf "%s\n" $(curl -s https://ipinfo.io/ip)
}
