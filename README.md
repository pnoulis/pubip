# About

Scripts that setup a Host behind a SOHO router to be publicly
accessible.

The capability to have a device automatically detect its network, join
it then make itself publicly available is very fundamental to many
circumstances.

For example:

- remote administrators often need to access a LAN Host from a remote
  location.
- Companies such as Anydesk need to control a LAN Host
- IP cameras, Door alarms,... need to be configured remotely at will
- Playstations have similar needs

My limited research so far has yielded 3 methods for implementing
this feature.

The 1st and 2nd method produce the same setup. Namely:

[ Any Host ] -> [ publicly accessible Host acting as a Proxy ] -> [ SOHO router ] -> [ LAN Host ]

The 3rd method does not interfere with the network setup in any way.
The Host does not truly become publicly accessible but can still be
reached at will from outside the LAN through the use of application
layer `hacks`.

## The 1st method

The first method demands from the user the technical skill,
willingness and time to make small adjustments to their network
configuration. This places limits to its deployment; A small business
acquiring your services or products would not be inclined nor expected
to have to undergo the setup process, unless this was done for them.
Even when the setup is complete, it would still be brittle as any
infrastructure change could potentially cause the configuration to
fall apart. In such a case, the customer would demand an immediate
fix, not to mention of the costs of any potential damage. For this
reason, this setup is mostly used either internally by businesses that
employ an IT department, businesses with a customer support desk, or
enthusiastic computer users, network professionals, programmers, DIY
folk and anyone with the willingness to learn. The benefits of the 1st
method especially when compared with the 3rd is its efficiency and
level of control over your network.

- Acquire a static public IP.

- Pick a Host to assign the static public IP to. This Host will act as
  the proxy. Connecting Hosts will have to go through the proxy to
  reach the LAN Host behind the SOHO router.

- The LAN Host is configured to have a static IP allocated by the DHCP
  server of the SOHO router.

  - This can be achieved either automatically or manually through the
    web page administration panel. For now, because of my lack of
    knowledge I will produce an example configuration for which the
    user is expected to copy in the appropriate file or run a script
    that installs it.

- The SOHO router is configured to perform port forwarding.

  - Manually for the 1st method. (through the web page administration
    panel of the router)
  - Automatically for the 3rd method.

- The LAN Host periodically or as a response to an event (such as a
  router reboot) pushes the SOHO router's WAN IP to the proxy Host.

## The 2nd method

The second method makes use of a new protocol called PCP (Port Control
Protocol). This protocol is usually found in routers. It provides a
LAN Host the ability to configure the Router automatically to forward
port traffic to it. (just like DHCP but for ports). I have yet to
research it and my own ISP router is lacking it but it seems that
since it is not widely available it suffers from the same drawbacks as
the first method. (at least until it is widely adopted). Other than
that, when it does become widely available it will make network
configuration even more automatic, since the only step that cannot be
made automatic in the 1st method is port forwarding; which has to go
through the web page administration panel.

- Acquire a static public IP.

- Pick a Host to assign the static public IP to. This Host will act as
  the proxy. Connecting Hosts will have to go through the proxy to
  reach the LAN Host behind the SOHO router.

- The LAN Host is automatically configured to have a static IP
  allocated by the DHCP server of the SOHO router.

- The SOHO router is automatically configured to perform port
  forwarding through the PCP server of the SOHO router.

- The LAN Host periodically or as a response to an event (such as a
  router reboot) pushes the SOHO router's WAN IP to the proxy Host.

## The 3rd method

The third method has no need to configure the network at all and as
such is much more widely used in commercial settings. It makes use of
`hacks` in the application layer of the TCP/IP protocol stack to give
the illusion that the LAN host is publicly accessible. Consider an
example application that needs to remotely access a LAN host's files;
the LAN host is acting as a filesystem server. In the usual HTTP
protocol, it is the originator Host who must initiate the interaction.
In our case that would be the Remote Host requesting access to the LAN
Host that is acting as the filesystem server. However, the LAN Host is
unreachable from our originator Host because it does not have a
publicly accessible IP. In order to overcome this problem, a client
application in the LAN Host is utilized. This client application
continuously initializes interactions with the Remote Host so that all
the Remote Host has to do in answer back. This "answer", which can be
given anytime by the Remote Host reverses the semantics of the
request-response cycle, so that the response becomes the request and
the request the response. This of course puts strains on the network
which is its major drawback and I do not know what it takes to
implement it (I have never tried it). However, its greatest benefit is
that it can be deployed anywhere, quickly without having to configure
the network making it great for commercial use (as long is their
internet connection can handle the load).

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


