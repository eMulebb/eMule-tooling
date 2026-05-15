# Network Guide

This guide covers connection setup, eD2K, Kad, binding, UPnP, firewall rules,
and practical network diagnosis.

## Network Surfaces

eMule BB uses the classic eMule network model:

- eD2K server connections for server-indexed search and source discovery
- Kad for decentralized search, source discovery, and firewall state
- TCP for incoming client connections
- UDP for Kad, source exchange, and protocol support traffic
- optional WebServer/REST listener for trusted local controllers

Low ID, firewalled Kad, or missing listen sockets usually means the app is
running but not reachable as intended.

## Bootstrap Sources

New or blank profiles use HTTPS bootstrap/update defaults:

- `addresses.dat` seeds server.met update URLs when missing or blank.
- The server page manual update field defaults to the primary HTTPS server.met URL.
- Kad bootstrap defaults to an HTTPS `nodes.dat` source.

Only direct machine-readable `server.met` and `nodes.dat` endpoints should be
used as built-in defaults. HTML download pages and stale direct files are not
good bootstrap sources.

## Ports

The main user-facing ports are:

- TCP client port: incoming client connections
- UDP client port: Kad and UDP protocol traffic
- server UDP port: legacy server UDP support
- WebServer/REST port: controller and web listener, if enabled

Changing ports while connected can be confusing. After changing TCP/UDP ports,
restart the session or reconnect, then re-run port tests.

## Binding

Binding is optional. Leave it empty unless you intentionally need a specific
interface or IP address.

Use interface binding when:

- the machine has multiple network interfaces
- a VPN interface must be used for P2P traffic
- you want startup to block networking if the target interface is unavailable

Use address binding only when:

- the selected interface has multiple IPv4 addresses and one must be chosen
- you understand that the address may disappear after network changes

If the configured binding target cannot be resolved, eMule BB reports the
active bind state in the UI and diagnostics. With startup bind blocking enabled,
P2P networking stays offline for that session instead of silently falling back.

## Windows Firewall

eMule BB includes an explicit Windows Firewall repair action. It launches an
elevated PowerShell repair script and creates broad allow rules for the eMule BB
executable:

- inbound TCP
- inbound UDP
- outbound TCP
- outbound UDP
- all profiles
- all local/remote ports and addresses

The repair action deletes exact-name eMule BB rules before recreating them, so
stale rules with the same names do not survive. It does not remove unrelated
legacy rules.

The repair output is visible in the elevated PowerShell window and is also
included in diagnostic snapshots after a repair attempt.

## UPnP

UPnP can map ports automatically when the router supports it and local policy
allows it. It is useful on home networks but not a substitute for knowing your
firewall and bind state.

If UPnP fails:

- verify the router supports UPnP
- check whether Windows Firewall allows eMule BB
- verify the app is bound to the expected interface
- test manual port forwarding

## eD2K Status

A healthy eD2K session has:

- a current server connection or deliberate disconnected state
- no unexpected Low ID
- a trusted server list
- stable server.met update source

Low ID usually points to incoming TCP reachability: firewall, router forwarding,
VPN/bind mismatch, or wrong external path.

## Kad Status

A healthy Kad session has:

- Kad running and connected
- nonzero users/files after bootstrap settles
- no persistent firewalled state when reachable inbound UDP is expected

Use Kad firewall recheck after changing ports, firewall rules, UPnP, router
mapping, or bind settings.

## WebServer And REST

REST uses the WebServer listener and `/api/v1` JSON contract. Legacy template
web UI is separate and should be enabled only explicitly when needed. REST is
the default controller path for eMule BB integrations.

Bind REST deliberately and keep API-key access on trusted networks.

## Practical Network Diagnosis

When connectivity is wrong:

1. Check current bind status.
2. Check whether TCP and UDP listen sockets exist in diagnostics.
3. Run the open ports test.
4. Recheck Kad firewall.
5. Repair Windows Firewall rules if local firewall state is suspect.
6. Check router/NAT forwarding.
7. Confirm server/Kad bootstrap files are current.
8. Review recent logs before changing more settings.

See [Diagnostics Guide](GUIDE-DIAGNOSTICS.md) and
[Troubleshooting Guide](GUIDE-TROUBLESHOOTING.md).
