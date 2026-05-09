# eMule Broadband Edition 1.0.1 Release Control

This is the active control document for `emule-bb-v1.0.1`. Release 1.0.1 is a
hardening release whose purpose is to prove that the Broadband line has not
regressed stock community behavior while preserving the advertised eMule BB,
REST, Arr, and aMuTorrent functionality shipped after 1.0.0.

## Release Identity

- Product name: `eMule broadband edition`
- Compact app/mod name: `eMule BB`
- Target tag: `emule-bb-v1.0.1`
- Baseline for stock/community behavior: `release/v0.72a-community`
- Candidate app line: `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main`
  on `main`
- Last public release tag for comparison: `emule-bb-v1.0.0`

## Definition Of 100% Functionality

Release 1.0.1 is complete only when each touched area has evidence for all of
the following:

- No regression from `release/v0.72a-community` for behavior that still exists
  in eMule BB.
- Full advertised eMule BB behavior remains implemented and tested.
- Native REST, qBittorrent-compatible, Torznab-compatible, Arr, and aMuTorrent
  workflows remain complete and diagnosable.
- Removed or frozen stock features are explicitly dispositioned as intentional
  product decisions, not silent regressions.
- Any discovered release-impacting bug has a tracked item, acceptance criteria,
  validation evidence, and a granular app or test commit.

## Control Documents

- [R-1.0.1 community parity audit plan](plans/RELEASE-1.0.1-COMMUNITY-PARITY-AUDIT.md)
- [R-1.0.1 community parity review](reviews/REVIEW-2026-05-09-release-1.0.1-community-parity.md)

## Release Gates

| ID | Gate | Status | Required outcome |
|----|------|--------|------------------|
| [CI-022](items/CI-022.md) | Changed-surface ledger | Done | Every changed file from community baseline is mapped to one release area, evidence lane, and item disposition. |
| [CI-023](items/CI-023.md) | Post-1.0 hardening replay | Done | BUG-102 through BUG-110 app commits are replayed with focused validation and traceability. |
| [CI-032](items/CI-032.md) | Post-tag focused coverage gaps | Done | Direct focused probes are added for post-1.0 fixes that previously had only indirect replay evidence. |
| [CI-024](items/CI-024.md) | Controller full replay | Done | Prowlarr, Radarr, Sonarr, and aMuTorrent live workflows pass or produce accepted public-network inconclusive evidence. |
| [CI-025](items/CI-025.md) | REST and adapter contract drift | Open | Native REST, qBit, and Torznab contracts are compared against manifests and live smoke artifacts. |
| [CI-026](items/CI-026.md) | Shared files/startup/long-path parity | Open | Large-tree, cache, watcher, long-path, share-ignore, and shared-file REST behavior are replayed. |
| [CI-027](items/CI-027.md) | Download and persistence replay | Open | Part-file, direct-download, completion hook, and metadata persistence behavior survive restart and failure probes. |
| [CI-028](items/CI-028.md) | Search, server, and Kad parity | Open | Server, Kad, source exchange, search lifecycle, and bootstrap flows are compared against community-compatible expectations. |
| [CI-029](items/CI-029.md) | Network adversity replay | Open | TCP, UDP, HTTPS, WebSocket, bind policy, and UPnP/NAT surfaces pass focused adversity and resource gates. |
| [CI-030](items/CI-030.md) | UI/preferences/language parity smoke | Open | Main shell, preferences, tray/menu behavior, keyboard shortcuts, list controls, and language resources receive smoke coverage. |
| [CI-031](items/CI-031.md) | Packaging and release asset parity | Open | x64 and ARM64 packaging, manifests, site config, dependency pins, and release assets are proven current. |
| [REF-037](items/REF-037.md) | Legacy/frozen feature disposition | Open | Removed or frozen stock features are recorded as intentional, restored, or converted into release blockers. |
| [FEAT-055](items/FEAT-055.md) | Improvement triage lane | Open | Non-blocking improvements are separated from R-1.0.1 blockers and queued without expanding release scope. |

## Candidate Decisions

| Candidate | R-1.0.1 decision rule |
|-----------|-----------------------|
| Broad legacy feature revival | Out of scope unless the feature still has a supported visible surface and the audit proves a user-facing regression. |
| New product features | Out of scope unless needed to complete already advertised eMule BB, Arr, or aMuTorrent behavior. |
| Deep dependency upgrades | Out of scope unless required to fix a release blocker. |
| Additional E2E coverage | In scope when it proves parity or prevents recurrence in a changed area. |
| Documentation-only improvements | In scope when they improve release proof, operator steps, or backlog accuracy. |

## Validation Rules

All build, test, and live validation commands must go through
`EMULE_WORKSPACE_ROOT\repos\eMule-build\workspace.ps1`.

Minimum release proof before tagging:

- `validate`
- Debug and Release app builds for x64
- Release app build for ARM64
- Debug and Release test builds for x64
- Native REST contract and adapter smoke replay
- Controller live E2E replay for aMuTorrent, Prowlarr, Radarr, and Sonarr
- Area-specific gates listed above
- Packaging and release asset rehearsal for x64 and ARM64

Public-network unavailable results are acceptable only when the harness records
the run as inconclusive with enough diagnostics to distinguish environment
failure from product failure.
