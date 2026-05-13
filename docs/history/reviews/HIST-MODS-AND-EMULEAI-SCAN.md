# eMuleAI And Mod Archive Broadband Scan

> Historical review/provenance. Current backlog state lives in `docs/active/`.

This is a long-form reference for comparing current `eMule-main` with
`analysis\emuleai` and `analysis\mods-archive`.

Active backlog state lives in `docs/active/`. If this reference conflicts with
`docs/active`, treat `docs/active` as authoritative.

## Branch Direction

The broadband edition should remain close to stock eMule by default:

- prefer hardening, responsiveness, and modern operational safety
- keep protocol and queue policy drift explicit
- make higher-drift features opt-in
- use eMuleAI and historical mods as references, not as wholesale import
  targets

## Already Landed In Current Main

The scan revalidated several feature families that are no longer merely
reference material:

| Area | Current-main status |
|---|---|
| Geo/location data | `FEAT-020` is done |
| Startup config override | `FEAT-022` is done |
| Shared startup cache and startup profiling | `FEAT-026` and `FEAT-027` are done |
| Shared Files list virtualization/hardening | `FEAT-028` is done |
| Disk-space floors and legacy import-flow retirement | `FEAT-033` is done |
| Shared-files watcher/live recursive sync | `FEAT-038` is done; monitored roots and watcher handoff are present |
| Automatic IP-filter update scheduling | `FEAT-042` is done |
| REST API core | `FEAT-013` is done |
| IP-filter safe promotion | `BUG-027` is done |
| Known-file metadata save hardening | `BUG-036` and the core `BUG-037` line are done |

## Newly Promoted Backlog Items

The 2026-04-26 scan added or refreshed these active backlog items:

| Item | Reason |
|---|---|
| `BUG-068` | eMuleAI v1.4 has progress-bar drawing safeguards that current `main` does not appear to carry |
| `FEAT-043` | eMuleAI's Known Clients large-history refresh model is a broadband-friendly performance candidate |
| `FEAT-044` | richer IP-filter input policy fits after the landed safe updater |
| `BUG-004` | eMuleAI IP-filter import breadth does not close overlap correctness semantics |
| `BUG-028` | eMuleAI reinforces the MediaInfo/id3lib retirement path |

## Existing Backlog Coverage

The following eMuleAI/mod features were already represented and were not
duplicated:

| Feature family | Existing item |
|---|---|
| CShield / anti-leecher protection panel | `FEAT-011` |
| uTP transport | `FEAT-018` |
| Dark mode | `FEAT-019` |
| Source saver / source cache | `FEAT-021` |
| Remote shared-file inventories | `FEAT-031` |
| IPv6 | `FEAT-035` |
| NAT traversal and extended LowID connectivity | `FEAT-036` |
| PowerShare, Share Only The Need, Hide Overshares | `FEAT-037` |
| Download Checker | `FEAT-039` |
| Headless/web/mobile control | `FEAT-040` |
| Download Inspector automation | `FEAT-041` |

## Deferred Findings

These remain useful references but were not promoted in this pass:

- built-in language resources and translator tooling
- broad toolbar, preview, own-credit, client-note, and copy-list UX expansion
- second connection-checker product surface beyond the existing Test Ports flow
- historical AICH known2 split/write-buffer work, unless later I/O hardening
  needs it as implementation reference
- full CShield manual-punishment UI outside the existing `FEAT-011` scope

## Implementation Guidance

When one of these items is implemented, revalidate against current `main` first.
Use the mod/eMuleAI code as behavior reference and keep the mainline shape small:

- preserve stock defaults unless the item explicitly says otherwise
- prefer opt-in controls for policy features
- avoid importing large UI surfaces as a side effect of a narrow hardening fix
- add targeted regression or live stress coverage for each user-visible surface
