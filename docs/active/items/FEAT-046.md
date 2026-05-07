---
id: FEAT-046
title: REST server and Kad bootstrap/import APIs
status: In Progress
priority: Major
category: feature
labels: [rest, servers, kad, bootstrap, live-wire]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Expose native REST operations for controlled server and Kad bootstrap/import
flows.

## Release 1.0 Classification

**Release Candidate.** Server import and Kad bootstrap coverage already exist
on current `main`. Finish Kad import for 1.0 only if live-wire bootstrap needs
a native refresh path; otherwise keep the remaining import work as a follow-up.

Default live sources are the already-persisted eMule Security URLs:

- `https://emule-security.org/`
- `https://upd.emule-security.org/server.met`
- `https://upd.emule-security.org/nodes.dat`

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](../plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Acceptance Criteria

- [x] server import can refresh `server.met` through the same safe validation
      and promotion path used by the app
- [x] Kad import can refresh `nodes.dat` without weakening the existing
      bootstrap-empty guard
- [x] endpoints support configured URLs and do not silently depend on bundled
      external lists
- [ ] live E2E records source URL, size, hash, and import outcome
- [ ] malformed downloads preserve the previous live files

## Progress

- 2026-05-02: Native `main` added `POST /api/v1/servers/met-url-imports`,
  `PATCH /api/v1/servers/{serverId}` property updates, and
  `POST /api/v1/kad/operations/bootstrap`. Route seam and live-smoke contract
  coverage were updated in `eMule-build-tests`.
- 2026-05-07: Native `main` added `POST /api/v1/kad/nodes-url-imports`,
  wired it to the existing validated `nodes.dat` URL import path, and added
  native route plus OpenAPI contract coverage. Live E2E still needs to record
  source URL, size, hash, import outcome, and malformed-download preservation
  evidence.

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- complements `BUG-071` and `BUG-072`
