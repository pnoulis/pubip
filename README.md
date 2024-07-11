# About

Scripts that setup a Host behind an SOHO router to be publicly

accessible.

There are possibly multiple solutions to this task.

For now, I will implement the following solution:

- The SOHO router is configured through DHCP to allocate a static IP to

  the LAN Host.

- The SOHO router is configured to forward some ports to the

  LAN Host.

- The LAN Host periodically or as a response to an event (such as a
  router reboot) pushes the SOHO router's WAN IP to the publicly
  accessible Host

- The public Host is configured to proxy requests intended for the LAN
  Host through the SOHO router's IP.


[ LAN Host ] -> [ publicly accessible proxy ] -> [ SOHO router ] -> [ LAN Host ]

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

