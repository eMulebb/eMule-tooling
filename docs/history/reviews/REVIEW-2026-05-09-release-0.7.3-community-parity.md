# Beta 0.7.3 Community Parity Review

- Date: 2026-05-09
- Baseline: `release/v0.72a-community`
- Candidate: `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` on
  `main`

## Executive Finding

The app delta from the community baseline to Broadband `main` is release-wide:
759 changed paths after excluding Visual Studio filter/user churn. The highest
Beta 0.7.3 risk is not one isolated defect; it is incomplete area-by-area proof
that each touched stock behavior remains compatible while Broadband-only REST,
Arr, aMuTorrent, startup, sharing, networking, and packaging behavior stays
complete.

The Beta 0.7.3 backlog therefore promotes proof gates first. Any product defect
found while closing those gates must become a granular `BUG-111+` item before
the release can be tagged.

The authoritative path-level ledger is
[REVIEW-2026-05-09-release-0.7.3-changed-surface-ledger](REVIEW-2026-05-09-release-0.7.3-changed-surface-ledger.md).

## Changed Surface Summary

Initial grouping from `git diff --name-only release/v0.72a-community...main`:

| Area | Approximate changed paths | Beta 0.7.3 risk |
|------|---------------------------|--------------|
| REST, WebServer, Arr, qBit, WebSocket | 24 | Adapter compatibility, auth, typed errors, static files, TLS/socket lifecycle. |
| Shared files, startup cache, long paths | 27 | Large library load, recursive share sync, cache migration, path handling, REST consistency. |
| Downloads, part files, persistence | 31 | Resume, metadata durability, direct download, completion hook, cancel/restart behavior. |
| Upload queue and bandwidth | 13 | Broadband scheduler drift from stock queue semantics and UI counters. |
| Search, server, Kad | 79 | Search lifecycle, bootstrap/import behavior, source exchange, UDP/Kad parsing. |
| Networking, sockets, UDP, UPnP | 40 | Bind policy, UPnP/NAT changes, HTTPS/WebSocket adversity, resource churn. |
| Preferences, config, UI shell | 112 | Preference persistence, pro-user controls, keyboard/tray/menu behavior, list-control safety. |
| GeoLocation, IPFilter, flags | 262 | Data refresh, country/flag display, resource footprint, update failure handling. |
| Legacy removals/frozen features | 27 | Intentional removals must not look like accidental regressions. |
| Build, packaging, resources, languages | 358 | x64/ARM64 assets, language projects, manifests, templates, docs, dependency integration. |

## Release-Blocking Backlog

| Item | Why it matters |
|------|----------------|
| [CI-022](../items/CI-022.md) | Prevents unmapped changed files from escaping release review. |
| [CI-023](../items/CI-023.md) | Ensures post-1.0 BUG-102..BUG-110 fixes are validated as a coherent patch release. |
| [CI-024](../items/CI-024.md) | Keeps the stated Arr/aMuTorrent parity claim from depending on stale 1.0.0 evidence. |
| [CI-025](../items/CI-025.md) | Catches drift between native REST, qBit compatibility, Torznab compatibility, and controller clients. |
| [CI-026](../items/CI-026.md) | Covers the highest-volume local-data path: shared files, startup cache, watchers, long paths. |
| [CI-027](../items/CI-027.md) | Covers user data durability and restart behavior for downloads and met files. |
| [CI-028](../items/CI-028.md) | Covers stock network-search behavior that Broadband changed indirectly. |
| [CI-029](../items/CI-029.md) | Replays the riskiest crash/leak/adversity paths after socket and UPnP changes. |
| [CI-030](../items/CI-030.md) | Ensures UI and preference changes did not regress stock user workflows. |
| [CI-031](../items/CI-031.md) | Prevents packaging or architecture drift from producing an unusable 0.7.3 asset. |
| [REF-037](../items/REF-037.md) | Forces every removed/frozen stock feature to be either intentional or restored. |

## Candidate Bug Watchlist

These are not confirmed product defects yet. They are the first places to look
for `BUG-111+` items while closing the gates.

| Watchpoint | Trigger for new bug item |
|------------|--------------------------|
| Post-tag hardening traceability | Any BUG-102..BUG-110 fix lacks a focused replay or has no release-area evidence. |
| Controller category/search semantics | Arr or aMuTorrent accepts malformed input, loses category state, or reports success for a failed nested request. |
| Shared startup cache migration | A stock profile fails to load, rescans unexpectedly, loses rows, or wedges shutdown/startup. |
| Download metadata durability | A crash/restart probe corrupts `part.met`, `known.met`, `known2.met`, `server.met`, or Kad preference snapshots. |
| Search teardown | Closing tabs, stopping searches, or refreshing server/Kad data leaves running work or stale UI rows. |
| Bind and UPnP behavior | Live tests write `hide.me` into `BindAddr`, disable P2P UPnP unexpectedly, or bind the WebServer through the wrong policy. |
| Legacy removals | A removed stock feature still has visible menu, resource, preference, or help surface that fails at runtime. |
| Language/resource packaging | Representative language DLLs or required resources fail to build, load, or show current commands. |

## Improvement Queue

Improvements are tracked separately from release blockers in
[FEAT-055](../items/FEAT-055.md). The first pass should rank:

- operator-facing release evidence summaries for live artifacts
- one-command Beta 0.7.3 proof orchestration through `python -m emule_workspace`
- automated changed-surface grouping for future releases
- lightweight UI smoke probes for representative language/resource loads
- clearer controller compatibility matrix for native REST, qBit, Torznab, Arr,
  and aMuTorrent consumers

## Required Next Action

Close [CI-022](../items/CI-022.md) first. That item creates the authoritative
changed-surface ledger, prevents duplicate review work, and decides whether any
changed path requires a new bug, test, refactor, or product-disposition item.
