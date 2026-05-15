# eMule BB Product Guide

eMule broadband edition, compactly eMule BB, keeps the classic eMule desktop
workflow while making the client more practical for modern Windows systems,
fast upload links, large shared libraries, and trusted local automation.

This is the product guide landing page. Use it as the starting point for user,
operator, and controller-facing documentation. Engineering release status still
lives in `docs/active/`; this guide explains how to run and understand the
product.

## Who It Is For

eMule BB is aimed at users who already understand why eD2K and Kad matter:

- power users running long-lived desktop sessions
- archivists and seeders with large shared directories
- users with broadband upload capacity that stock slot behavior does not model well
- operators who want local controller access without giving up the native app
- contributors who want release evidence, diagnostics, and reproducible behavior

The product is intentionally not a rewrite. Stock protocol compatibility and the
familiar eMule workflow remain the baseline.

## Quick Start

For a new profile:

1. Start eMule BB and complete the first-run setup.
2. Confirm incoming, temporary, and shared directories.
3. Review `Preferences > Connection`, especially TCP/UDP ports, UPnP, and bind settings.
4. Connect to eD2K and/or Kad with trusted bootstrap sources.
5. Review `Preferences > Security > IP Filter` if you use filtering.
6. Add a small download or search first, then scale to larger workloads.
7. Use Tools menu diagnostics before changing many settings at once.

For a stock eMule profile:

1. Keep a backup of the existing config directory.
2. Reuse the profile only after confirming `preferences.dat`, `server.met`,
   `nodes.dat`, `known.met`, and `.part.met` are intact.
3. Let eMule BB create BB-only sidecar files as needed.
4. Avoid round-tripping the same live profile back into older stock builds.

## Product Guide Map

| Need | Guide |
|---|---|
| First run, profiles, defaults, config backups | [Setup Guide](GUIDE-SETUP.md) |
| eD2K, Kad, server.met, nodes.dat, binding, firewall, UPnP | [Network Guide](GUIDE-NETWORK.md) |
| Tools menu, tray quick actions, config editors, maintenance | [Tools Menu Guide](GUIDE-TOOLS-MENU.md) |
| Shared directories, monitored shares, long paths, large libraries | [Sharing Guide](GUIDE-SHARING.md) |
| Downloads, search, fake/trust feedback, categories | [Downloads and Search Guide](GUIDE-DOWNLOADS-SEARCH.md) |
| Preferences, persistence, reset behavior, UI mapping | [Preferences Guide](GUIDE-PREFERENCES.md) |
| Logs, snapshots, dumps, firewall repair evidence | [Diagnostics Guide](GUIDE-DIAGNOSTICS.md) |
| REST, aMuTorrent, Arr, qBit, Torznab integration | [Controllers and REST Guide](GUIDE-CONTROLLERS-REST.md) |
| Symptom-led fixes | [Troubleshooting Guide](GUIDE-TROUBLESHOOTING.md) |
| Keyboard workflow | [Keyboard Shortcuts](KEYBOARD-SHORTCUTS.md) |
| IP filter details | [IP Filter Guide](GUIDE-IP-FILTERS.md) |
| Long path behavior | [Long Path Guide](GUIDE-LONGPATHS.md) |

## Operating Model

Treat eMule BB like a native eMule client first and a controller endpoint
second. The desktop app owns the authoritative state for network connection,
search, transfers, sharing, categories, and local files. REST and companion
tools are adapters around that native behavior.

Good operation is usually boring:

- keep ports, bind targets, and firewall rules deliberate
- keep share roots predictable
- use categories before adding automation
- prefer finite transfer limits over unlimited experiments
- make one settings change at a time and observe the result
- collect diagnostics before wiping or rebuilding a profile

## Compatibility Notes

Core eMule data remains compatible where possible: `preferences.dat`,
`clients.met`, `cryptkey.dat`, `known.met`, `known2.met`, `cancelled.met`,
`.part.met`, `server.met`, and `nodes.dat` remain the important profile state.

eMule BB also writes BB-specific sidecars and preferences such as
`shareignore.dat`, monitored-share files, shared-library startup caches,
REST-related settings, and UI schema migration markers. Older stock clients
usually ignore unknown preferences, but they do not understand all BB sharing
policy or cache sidecars.

## Release Status

The active beta release status is not duplicated here. For release proof,
package status, and current blockers, use:

- [Beta 0.7.3 dashboard](../active/RELEASE-0.7.3.md)
- [Beta 0.7.3 checklist](../active/RELEASE-0.7.3-CHECKLIST.md)
- [Beta 0.7.3 runbook](../active/RELEASE-0.7.3-RUNBOOK.md)
- [Active backlog index](../active/INDEX.md)

## Maintenance Rule

When a user-visible feature changes, update the focused guide that owns it.
Do not bury product behavior only in release notes, backlog items, or source
comments.
