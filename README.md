# About

Scripts that setup a Host behind an internet gateway to be publicly

accessible.

There are multiple solutions to this task.

For now, I will implement the following solution:

- The gateway is configured through DHCP to allocate a static IP to

  the LAN Host.

- The gateway is configured to forward some ports to the LAN Host.

- The Host periodically pushes the gateway's WAN IP to a Host behind
  a static public IP.

- The static public IP Host is configured to proxy requests intended

  for the LAN Host behind the gateway by having the most updated

  version of the gateway's public WAN IP.


[ Host ] -> [ proxy ] -> [ internet gateway ] -> [ LAN Host ]


## Getting started

### Prerequisites

### Installation

## Usage

## Contributing

pull request

## License

- GPLv3 see `LICENSE`

## Contact

- pavlos noulis <pavlos.noulis@gmail.com> (github.com/pnoulis)





