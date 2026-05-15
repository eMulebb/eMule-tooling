# IP Filter Guide

eMule BB uses `ipfilter.dat` to reject peers, sources, Kad contacts, and
optionally servers whose IP ranges match loaded filter rules. IP filtering is a
maintenance and abuse-reduction aid. It is not a privacy substitute for correct
network binding, firewall rules, or VPN operation.

## Where Settings Are Stored

The active update URL is stored in the normal preferences file:

- file: `config\preferences.ini`
- section: `[eMule]`
- key: `IPFilterUpdateUrl`

The Security page dropdown history is separate:

- file: `config\AC_IPFilterUpdateURLs.dat`
- format: UTF-16 text with one URL per line

When `AC_IPFilterUpdateURLs.dat` is missing or has no usable entries, eMule BB
seeds it with built-in suggestions. Existing non-empty user history is left
unchanged.

## Seeded URL Suggestions

The seeded dropdown suggestions are:

1. `https://upd.emule-security.org/ipfilter.zip`
2. `https://emuling.gitlab.io/ipfilter.zip`
3. `https://github.com/DavidMoore/ipfilter/releases/download/lists/ipfilter.zip`
4. `https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz`

The HTTPS eMule-Security URL is the default active URL for new profiles. The
other entries are suggestions for users who want a fallback or a torrent-style
PeerGuardian blocklist source.

## Supported Download Formats

The IP filter updater accepts:

- ZIP archives containing `ipfilter.dat`, `guarding.p2p`, or `guardian.p2p`
- GZip-compressed filter files
- RAR archives when RAR support is available
- plain `ipfilter.dat` style text
- PeerGuardian-style text
- PeerGuardian binary files

After a successful update, eMule BB promotes the downloaded filter into
`config\ipfilter.dat`, reloads the running filter table, and shows the loaded
rule count in `Preferences > Security > IP Filter`.

## Practical Use

Enable `Preferences > Security > IP Filter` to apply loaded rules. The filter
file can still exist when the checkbox is disabled, but it will not block peers
until filtering is enabled again.

The compact stats line shows:

- whether filtering is currently enabled
- how many IP filter rules are loaded
- the current filter level

Use **Reload** after manually editing `ipfilter.dat`. Use **Load** after
changing the update URL and wanting an immediate refresh.
