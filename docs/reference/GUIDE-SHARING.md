# Sharing Guide

This guide covers shared directories, monitored shares, large libraries, long
paths, and share policy files.

## Sharing Model

eMule BB keeps classic eMule sharing behavior: files in configured shared
directories are published through eD2K/Kad according to normal network state and
local queue policy.

Good sharing starts with intentional directories:

- avoid sharing broad roots such as entire drives
- keep incomplete downloads in Temp, not in shared roots
- keep completed downloads in Incoming or curated share roots
- use stable paths where possible
- avoid high-churn directories unless monitoring is intentional

## Shared Directory Files

Important sharing files:

| File | Purpose |
|---|---|
| `shareddir.dat` | Main shared directory list |
| `shareddir.monitored.dat` | Directories watched for automatic share changes |
| `shareddir.monitor-owned.dat` | Directories added by monitor ownership |
| `shareignore.dat` | Ignore rules for share scanning |
| `sharedcache.dat` | Startup cache for large shared libraries |
| `shareddups.dat` | Duplicate path cache |

Use Tools menu editors for careful maintenance and the Shared Files page for
normal operation.

## Monitored Shares

Monitored shares are useful when another workflow deposits files into a known
directory. They reduce manual reload work, but they should be scoped narrowly.

Good monitored-share targets:

- a curated completed media folder
- a dedicated incoming archive folder
- a stable folder controlled by a trusted automation tool

Poor monitored-share targets:

- a whole drive
- temp build directories
- browser download folders
- cloud-sync roots with constant churn

## Share Ignore Rules

Use `shareignore.dat` to avoid publishing unwanted file patterns or paths.
After editing, use Tools maintenance to reload share-ignore rules.

Share-ignore is BB-specific policy. Older stock clients do not understand why a
directory or file was ignored by eMule BB.

## Large Library Operation

Large libraries need predictable scanning:

- keep roots stable
- avoid recursive noise
- use long-path capable Windows setup for deep trees
- let startup cache settle
- avoid judging performance during first scan
- rescan explicitly after major directory changes

Startup cache and duplicate path cache are acceleration files. If removed, the
app can rebuild them, but the next startup or scan may be slower.

## Long Paths

Deep library trees can exceed old Windows path limits. eMule BB has long-path
hardening, but the host system and target filesystem still matter. For details,
use [Long Path Guide](GUIDE-LONGPATHS.md).

## Shared Files UI

The Shared Files page is the main user-facing view for:

- visible shared files
- file details
- ED2K links
- open file/folder actions
- reload/rescan behavior
- sorting and curation columns

Use view presets if old profiles hide useful columns or preserve cramped widths.

## REST Sharing Surface

REST exposes shared files and shared directories for trusted controllers. Native
UI state remains authoritative. If REST and UI appear to disagree, wait for
hashing/scanning to settle, then compare current REST shared-file snapshots with
the Shared Files page.

## Recovery

If sharing behavior looks wrong:

1. Check the configured share roots.
2. Check `shareignore.dat`.
3. Reload share-ignore rules.
4. Rescan shared files.
5. Review diagnostics for startup cache state.
6. Remove stale cache sidecars only if you intentionally want a rebuild.
