# eMule Broadband Edition 0.7.3 Beta Release Control

This is the active control document for beta target `emule-bb-v0.7.3`.
Beta 0.7.3 is the first intended beta/public release for the Broadband line.
It must prove that eMule BB has not regressed stock community behavior while
preserving the advertised REST, Arr, and aMuTorrent functionality.

The earlier `emule-bb-v1.0.0` and `emule-bb-v1.0.1` tags, plus the temporary
`1.1.1` package rehearsal default, are superseded internal evidence labels.
They must not be published as public releases or package assets.

## Release Identity

- Product name: `eMule broadband edition`
- Compact app/mod name: `eMule BB`
- Target tag: `emule-bb-v0.7.3`
- Release visibility: beta/public candidate
- Public release floor: `emule-bb-v0.7.3`
- Package publication: allowed only after the final 0.7.3 proof passes
- Tag status: not tagged yet
- Baseline for stock/community behavior: `release/v0.72a-community`
- Candidate app line: `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main`
  on `main`
- Previous superseded evidence tags: `emule-bb-v1.0.0`,
  `emule-bb-v1.0.1`

## Definition Of 100% Functionality

Beta 0.7.3 is complete only when each touched area has evidence
for all of the following:

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

- [Beta 0.7.3 community parity audit plan](plans/RELEASE-0.7.3-COMMUNITY-PARITY-AUDIT.md)
- [Beta 0.7.3 community parity review](reviews/REVIEW-2026-05-09-release-0.7.3-community-parity.md)

## Release Gates

| ID | Gate | Status | Required outcome |
|----|------|--------|------------------|
| [CI-022](items/CI-022.md) | Changed-surface ledger | Done | Every changed file from community baseline is mapped to one release area, evidence lane, and item disposition. |
| [CI-023](items/CI-023.md) | Post-1.0 hardening replay | Done | BUG-102 through BUG-110 app commits are replayed with focused validation and traceability. |
| [CI-032](items/CI-032.md) | Post-tag focused coverage gaps | Done | Direct focused probes are added for post-1.0 fixes that previously had only indirect replay evidence. |
| [CI-024](items/CI-024.md) | Controller full replay | Done | Prowlarr, Radarr, Sonarr, and aMuTorrent live workflows pass or produce accepted public-network inconclusive evidence. |
| [CI-025](items/CI-025.md) | REST and adapter contract drift | Done | Native REST, qBit, and Torznab contracts are compared against manifests and live smoke artifacts. |
| [CI-026](items/CI-026.md) | Shared files/startup/long-path parity | Done | Large-tree, cache, watcher, long-path, share-ignore, and shared-file REST behavior are replayed. |
| [CI-027](items/CI-027.md) | Download and persistence replay | Done | Part-file, direct-download, completion hook, and metadata persistence behavior survive restart and failure probes. |
| [CI-028](items/CI-028.md) | Search, server, and Kad parity | Done | Server, Kad, source exchange, search lifecycle, and bootstrap flows are compared against community-compatible expectations. |
| [CI-029](items/CI-029.md) | Network adversity replay | Done | TCP, UDP, HTTPS, WebSocket, bind policy, and UPnP/NAT surfaces pass focused adversity and resource gates. |
| [CI-030](items/CI-030.md) | UI/preferences/language parity smoke | Done | Main shell, preferences, tray/menu behavior, keyboard shortcuts, list controls, and language resources receive smoke coverage. |
| [CI-031](items/CI-031.md) | Packaging and release asset parity | Done | x64 and ARM64 packaging, manifests, site config, dependency pins, and release assets are proven current. |
| [REF-037](items/REF-037.md) | Legacy/frozen feature disposition | Done | Removed or frozen stock features are recorded as intentional, restored, or converted into release blockers. |
| [FEAT-055](items/FEAT-055.md) | Improvement triage lane | Done | Non-blocking improvements are separated from Beta 0.7.3 blockers and queued without expanding release scope. |
| [CI-033](items/CI-033.md) | Final release-candidate proof | Done | Current candidate passes the minimum release proof before tagging. |

All carried-forward beta proof gates are closed from the superseded internal
evidence pass. The final 0.7.3 proof must be refreshed on current `main`
before tagging because app and package-version commits landed after
`emule-bb-v1.0.1`.

The superseded internal release-candidate proof is recorded in
[CI-033](items/CI-033.md). It passed on app commit `11e5966` with local package
rehearsal assets:

- `eMule-broadband-1.0.1-x64.zip`:
  `a9649e201c10d8866fa9d46fd01960c0bbf3daa1830c45c2c90d2616b59bdbeb`
- `eMule-broadband-1.0.1-arm64.zip`:
  `b58697f2678dce455e569dffa009355180be14cee243b982e412bb5a66c8de97`

The annotated app tag `emule-bb-v1.0.1` was pushed after CI-033 passed. It is
now superseded by the 0.7.3 beta release line. Do not create a public GitHub
release or upload packages for `emule-bb-v1.0.0`, `emule-bb-v1.0.1`, or any
temporary `1.1.1` rehearsal asset.

Current 0.7.3 package rehearsal evidence is recorded in [CI-031](items/CI-031.md):

- `eMule-broadband-0.7.3-x64.zip`:
  `deec659b720f89eed38c22ab7defb6bafb9dc3dee38c691c54dbd85b9e1d4206`
- `eMule-broadband-0.7.3-arm64.zip`:
  `45d1f24eb996879322978f02f9ccebae15bee20b30b5fcf8a7be437eee06697b`

The package rehearsal passed on app commit `74e5c76`, build commit `0ead21a`,
and tooling commit `2d904c3`. Do not create or push the `emule-bb-v0.7.3` tag
yet; tagging is explicitly held until the remaining minimum beta proof below is
complete and the operator gives a separate tagging instruction.

## Candidate Decisions

| Candidate | Beta 0.7.3 decision rule |
|-----------|-----------------------|
| Broad legacy feature revival | Out of scope unless the feature still has a supported visible surface and the audit proves a user-facing regression. |
| New product features | Out of scope unless needed to complete already advertised eMule BB, Arr, or aMuTorrent behavior. |
| Deep dependency upgrades | Out of scope unless required to fix a release blocker. |
| Additional E2E coverage | In scope when it proves parity or prevents recurrence in a changed area. |
| Documentation-only improvements | In scope when they improve release proof, operator steps, or backlog accuracy. |

## Validation Rules

All build, test, and live validation commands must go through
`python -m emule_workspace`.

Minimum beta proof before tagging:

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
