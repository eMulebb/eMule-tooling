# Setup Guide

This guide covers the first-run and profile model for eMule BB.

## Install Model

eMule BB is a native Windows desktop application. The public package is a
portable-style application directory plus the normal eMule config directory.
Keep the application directory and profile/config directory distinct in your
mind:

- executable directory: the program and bundled runtime assets
- config directory: identity, preferences, server/Kad state, lists, logs, and local sidecars
- temp directory: incomplete download parts
- incoming directory: completed downloads
- shared directories: user-selected publish roots

The app can run long-lived unattended sessions, but it is still a desktop
client. Start by proving the native UI works before adding controller tools.

## New Profile Checklist

For a clean profile:

1. Start eMule BB.
2. Choose incoming and temporary directories.
3. Configure TCP and UDP ports in `Preferences > Connection`.
4. Enable UPnP only if your router and network policy allow it.
5. Leave bind settings empty unless you intentionally need a specific interface or IP.
6. Connect to a trusted eD2K server list and/or Kad.
7. Configure IP filtering only if you maintain a filter source.
8. Add shared directories gradually, then verify the Shared Files page.

Avoid importing large share roots, controller automation, and aggressive network
tuning all at once. Make the base session healthy first.

## Existing Profile Checklist

Before reusing a stock profile:

- copy the whole config directory as a rollback backup
- confirm active downloads are not mid-edit in another client
- keep the same temp and incoming paths when possible
- start eMule BB once without automation
- verify connection state, current downloads, shared files, and categories

eMule BB creates extra sidecar files for broadband behavior, diagnostics,
sharing policy, and caches. These are local additions and should be left in
place unless you intentionally reset that feature.

## Configuration Files

Common profile files:

| File | Purpose |
|---|---|
| `preferences.ini` | Most UI and BB-specific settings |
| `preferences.dat` | Core identity and legacy binary preferences |
| `server.met` | eD2K server list |
| `nodes.dat` | Kad bootstrap/contact state |
| `known.met`, `known2.met` | Known shared-file state |
| `.part.met` files | Incomplete download metadata |
| `Category.ini` | Download categories |
| `ipfilter.dat` | Loaded IP filter rules |
| `addresses.dat` | server.met update URL list |
| `AC_IPFilterUpdateURLs.dat` | IP filter update URL history |
| `shareignore.dat` | Share ignore rules |
| `shareddir.dat` | Shared directory list |
| `shareddir.monitored.dat` | Monitored share roots |
| `shareddir.monitor-owned.dat` | Share roots owned by the monitor |

The Tools menu exposes editors for many text config files. Use the app UI for
normal settings and direct file edits for controlled maintenance.

## Defaults And Seeding

When selected text config files are missing or empty, eMule BB seeds practical
defaults. Examples include server.met update sources and IP filter update
suggestions. Existing non-empty user files are preserved.

The default server.met update source is HTTPS. Kad bootstrap also uses an HTTPS
source by default where available. See the current
[Network Guide](../../reference/GUIDE-NETWORK.md) and
[IP Filter Guide](../../reference/GUIDE-IP-FILTERS.md).

## Backup Model

At startup, eMule BB can create rolling config backups. Treat these as a local
safety net, not a replacement for your own release-upgrade backup. Before a
major profile migration, copy the whole config directory while the app is not
running.

Useful backup targets:

- core identity files
- active `.part.met` and `.part` files
- `server.met` and `nodes.dat`
- `preferences.ini` and `preferences.dat`
- category and sharing files

## Reset Behavior

On the first eMule BB run, selected old UI table settings can be reset so the
new column layout is usable. The reset is controlled by a BB-owned preference
schema marker rather than by app version text. Tools menu view presets can also
apply stock, extended, or full table layouts with optional width reset.

## Upgrade Discipline

For a clean upgrade:

- close eMule BB normally
- keep the config directory unchanged
- replace the application files
- start once without controllers
- check logs and diagnostics if startup is slower than expected

Do not run multiple eMule-family clients against the same live profile at the
same time.
