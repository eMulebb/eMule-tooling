---
id: AMUT-002
title: aMuTorrent transfer detail hydration
status: Open
priority: Major
category: integration
labels: [amutorrent, rest, transfers, controller]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Hydrate aMuTorrent transfer detail views from eMule BB REST once the backend
exposes the required detail endpoint.

## Release 1.0 Classification

**Release Candidate.** This depends on `FEAT-045`. It becomes a 1.0 blocker
only if `AMUT-001` cannot provide useful release transfer views without detail
hydration; otherwise it remains a compatible enhancement.

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](../plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Current Gap

The eMule BB adapter currently maps transfer rows and sources, but leaves
segment-oriented fields such as `partStatus`, `gapStatus`, and `reqStatus` as
placeholders.

## Acceptance Criteria

- [ ] adapter detects the transfer-detail capability before calling the new
      endpoint
- [ ] detail payload is merged into transfer models without breaking existing
      list rendering
- [ ] missing detail support degrades cleanly on older eMule BB builds
- [ ] Node adapter tests and browser smoke coverage verify hydrated details

## Relationship To Other Items

- depends on `FEAT-045`
- backs `AMUT-001`
