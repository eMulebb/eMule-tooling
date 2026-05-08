# eMule Broadband Edition 1.0 Release Control

This is the active control document for `emule-bb-v1.0.0`. It owns Release 1
gate status, candidate decisions, and final readiness rules.

Current status: `release/v0.72a-broadband` is a pre-release stabilization
branch, not ready for an official release. Do not tag or package
`emule-bb-v1.0.0` until the gates below are revalidated and the operator steps
in the checklist and runbook are complete.

Operator docs:

- [Release 1.0 checklist](RELEASE-1.0-CHECKLIST.md)
- [Release 1.0 runbook](RELEASE-1.0-RUNBOOK.md)
- [REST/Arr execution plan](plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md)
- [Live E2E execution plan](plans/RELEASE-1.0-LIVE-E2E-EXECUTION-PLAN.md)
- [Download completion hook execution plan](plans/RELEASE-1.0-DOWNLOAD-COMPLETION-HOOK-EXECUTION-PLAN.md)
- [NAT mapping execution plan](plans/RELEASE-1.0-NAT-MAPPING-EXECUTION-PLAN.md)
- [R1 stability blockers execution plan](plans/RELEASE-1.0-STABILITY-BLOCKERS-EXECUTION-PLAN.md)

## Release Identity

- Product name: `eMule broadband edition`
- Compact app/mod name: `eMule BB`
- Release tag: `emule-bb-v1.0.0`
- Release assets:
  - `eMule-broadband-1.0.0-x64.zip`
  - `eMule-broadband-1.0.0-arm64.zip`

## Release Gates

These gates must remain passed, or be explicitly revalidated if their evidence
ages out or related code changes.

Current REST hardening focus: revalidate both the native `/api/v1` contract and
the Arr/qBittorrent-compatible adapter APIs before tagging. The detailed pending
task queue lives in the
[REST/Arr execution plan](plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md#current-revalidation-focus).
aMuTorrent remains the primary UI proof target, but it adapts to the clean
native `/api/v1` design and must not drive native route shape, aliases,
envelopes, or validation policy.

Current stability focus: the first adversarial current-branch findings from the
2026-05-08 R1 review are closed on `main`, but the follow-up pass added
[BUG-089](items/BUG-089.md) through [BUG-091](items/BUG-091.md) as open R1
blockers. Keep their evidence and closure flow in the
[R1 stability blockers execution plan](plans/RELEASE-1.0-STABILITY-BLOCKERS-EXECUTION-PLAN.md).

| ID | Gate | Status | Evidence pointer |
|----|------|--------|------------------|
| [BUG-075](items/BUG-075.md) | REST typed error consistency | Passed | item completion evidence |
| [BUG-076](items/BUG-076.md) | Malformed WebServer/REST hardening | Passed | item completion evidence |
| [BUG-077](items/BUG-077.md) | Concurrent WebServer soak | Passed | item completion evidence |
| [CI-011](items/CI-011.md) | Release live E2E umbrella | Done | item completion evidence and latest full `live-e2e` report |
| [CI-014](items/CI-014.md) | REST manifest/live completeness gate | Passed | item completion evidence |
| [CI-015](items/CI-015.md) | REST malformed/concurrent matrix | Passed | item completion evidence |
| [AMUT-001](items/AMUT-001.md) | aMuTorrent live E2E validation | Passed | item completion evidence |
| [AMUT-002](items/AMUT-002.md) | aMuTorrent transfer detail hydration | Passed | item completion evidence and latest aMuTorrent browser smoke report |
| [ARR-001](items/ARR-001.md) | Arr live E2E validation | Passed | item completion evidence |
| [FEAT-050](items/FEAT-050.md) | Download completion hook | Passed | item completion evidence |
| [BUG-078](items/BUG-078.md) | qBit auth fails closed on session RNG failure | Done | app `02fd5bf`, tests `dfc86d6`, Release x64 validation |
| [BUG-079](items/BUG-079.md) | WebSocket accepted-client shutdown lifetime | Done | app `aa66699`, Release x64 validation |
| [BUG-080](items/BUG-080.md) | WebSocket shutdown avoids `TerminateThread` | Done | app `aa66699`, Release x64 validation |
| [BUG-081](items/BUG-081.md) | HTTPS WebSocket WANT_READ/WANT_WRITE loops yield to socket waits | Done | app `aa66699`, Release x64 validation |
| [BUG-082](items/BUG-082.md) | GeoLocation/IPFilter refresh state cannot wedge | Done | app `e5c8f81`, Release x64 validation |
| [BUG-083](items/BUG-083.md) | Client UDP malformed-packet logging is bounds-safe | Done | app `1af8bb5`, tests `cfe9b96`, Release x64 validation |
| [BUG-084](items/BUG-084.md) | Web admin process token handles are closed | Done | app `1513358`, Release x64 validation |
| [BUG-085](items/BUG-085.md) | Kad/client UDP encryption gating has compatibility proof | Done | app `2ee49ab`, tests `2d5cc1a`, Release x64 validation |
| [BUG-086](items/BUG-086.md) | HTTPS WebSocket mbedTLS socket context ABI is safe | Done | app `c6c1526`, Release x64 validation |
| [BUG-087](items/BUG-087.md) | HTTPS WebSocket queued TLS writes cannot stall on WANT_READ | Done | app `dfcf1fe`, Release x64 validation |
| [BUG-088](items/BUG-088.md) | WebSocket failed shutdown cannot poison restart | Done | app `7a5de38`, Release x64 validation |
| [BUG-089](items/BUG-089.md) | UDP control sender is exception-safe under `sendLocker` | Open | follow-up review finding; execution plan pending |
| [BUG-090](items/BUG-090.md) | Background refresh completion cannot wedge on failed UI post | Open | follow-up review finding; execution plan pending |
| [BUG-091](items/BUG-091.md) | DirectDownload rejects close-time persistence failures | Open | follow-up review finding; execution plan pending |

## Candidate Decisions

These items are desirable but are not Release 1 blockers unless a later gate
failure proves that they are required.

| ID | Candidate | Release 1 decision |
|----|-----------|--------------------|
| [FEAT-032](items/FEAT-032.md) | NAT mapping live validation | Deferred; Release E2E did not require NAT proof |
| [FEAT-045](items/FEAT-045.md) | Transfer detail endpoint | Passed; promoted with `AMUT-002` capability-gated aMuTorrent consumption |
| [FEAT-046](items/FEAT-046.md) | Server/Kad bootstrap/import APIs | Passed; server.met import, Kad bootstrap, nodes.dat URL import, malformed preservation, and live seed import evidence are covered |
| [FEAT-047](items/FEAT-047.md) | Search API completeness | Passed; OpenAPI and REST contract document Release 1 behavior |
| [FEAT-048](items/FEAT-048.md) | Upload queue control completeness | Passed; existing controls are covered, unsupported operations return typed errors, and no new queue mutation was promoted |
| [FEAT-049](items/FEAT-049.md) | Curated REST preference expansion | Passed; aMuTorrent needs no additional runtime preference keys and the curated surface has live round-trip plus bad-value coverage |

## Execution Plans

Each Release 1 gate and candidate is covered by exactly one cluster execution
plan. Item docs keep acceptance criteria and evidence; the plans own detailed
closure and revalidation flow.

| Plan | Covered items |
|------|---------------|
| [REST/Arr execution plan](plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md) | [BUG-075](items/BUG-075.md), [BUG-076](items/BUG-076.md), [BUG-077](items/BUG-077.md), [CI-014](items/CI-014.md), [CI-015](items/CI-015.md), [AMUT-001](items/AMUT-001.md), [ARR-001](items/ARR-001.md), [FEAT-045](items/FEAT-045.md), [FEAT-046](items/FEAT-046.md), [FEAT-047](items/FEAT-047.md), [FEAT-048](items/FEAT-048.md), [FEAT-049](items/FEAT-049.md), [AMUT-002](items/AMUT-002.md) |
| [Live E2E execution plan](plans/RELEASE-1.0-LIVE-E2E-EXECUTION-PLAN.md) | [CI-011](items/CI-011.md) |
| [Download completion hook execution plan](plans/RELEASE-1.0-DOWNLOAD-COMPLETION-HOOK-EXECUTION-PLAN.md) | [FEAT-050](items/FEAT-050.md) |
| [NAT mapping execution plan](plans/RELEASE-1.0-NAT-MAPPING-EXECUTION-PLAN.md) | [FEAT-032](items/FEAT-032.md) |
| [R1 stability blockers execution plan](plans/RELEASE-1.0-STABILITY-BLOCKERS-EXECUTION-PLAN.md) | [BUG-078](items/BUG-078.md), [BUG-079](items/BUG-079.md), [BUG-080](items/BUG-080.md), [BUG-081](items/BUG-081.md), [BUG-082](items/BUG-082.md), [BUG-083](items/BUG-083.md), [BUG-084](items/BUG-084.md), [BUG-085](items/BUG-085.md), [BUG-086](items/BUG-086.md), [BUG-087](items/BUG-087.md), [BUG-088](items/BUG-088.md), [BUG-089](items/BUG-089.md), [BUG-090](items/BUG-090.md), [BUG-091](items/BUG-091.md) |

## Deferred Scope

The following tracks stay outside the first public release unless a later
release-readiness review promotes a concrete blocker:

- exploratory Boost and CMake adoption ideas: `REF-008` through `REF-014`,
  `CI-001`
- broad CI/toolchain migration: `CI-002` through `CI-007`, `CI-010`
- dependency upgrades: `REF-028`, `REF-034`
- broad networking work: `REF-029`, `REF-030`, `FEAT-018`, `FEAT-035`,
  `FEAT-036`
- broad product/UI expansion: `FEAT-017`, `FEAT-019`, `FEAT-021`,
  `FEAT-031`, `FEAT-037`, `FEAT-039` through `FEAT-044`
- non-release hardening watchpoints: `BUG-031`, `BUG-034`, `BUG-035`,
  `FEAT-001` through `FEAT-006`, `FEAT-034`, `CI-008`, `CI-012`,
  `CI-013`

## Validation

Before tagging `emule-bb-v1.0.0`, run the supported workspace commands:

- `pwsh -File repos\eMule-build\workspace.ps1 validate`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
- `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`
- native parity tests through the supported `test` command
- Release x64 `live-e2e`, including aMuTorrent, Prowlarr, Radarr, and Sonarr

Public-network unavailable results are acceptable only when the harness records
the run as inconclusive with enough diagnostics to distinguish environment
failure from product failure.
