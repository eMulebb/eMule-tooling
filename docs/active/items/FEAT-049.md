---
id: FEAT-049
title: Curated REST preference expansion
status: Passed
priority: Minor
category: feature
labels: [rest, preferences, controller, settings]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Expand `/api/v1/app/preferences` only for settings that are useful to local
controllers and safe to mutate through REST.

## Beta 0.7.3 Classification

**Release Candidate.** Keep the first-release preference surface curated. Add
only settings required by aMuTorrent or release automation; risky debug,
compatibility, and protocol internals stay private.

## Execution Plan

Historical release context: [Beta 0.7.3 REST and Arr execution plan](../../history/release-0.7.3/RELEASE-0.7.3-REST-ARR-EXECUTION-PLAN.md).

## Acceptance Criteria

- [x] missing aMuTorrent-relevant settings are identified by direct adapter/UI
      needs
- [x] risky compatibility, debug, and protocol internals remain unexposed
- [x] all mutable preferences round-trip through normal preference persistence
- [x] bad values return typed REST errors
- [x] native and live REST tests cover every new key

## Progress

- 2026-05-07: Audited the active aMuTorrent eMule BB integration. It needs
  connection metadata and the configured API key, not additional eMule runtime
  preference keys for Release 1. The current curated preference surface stays
  intentionally narrow.
- 2026-05-07: Strengthened live REST smoke coverage so every currently curated
  preference key is read and no-op patched back through `/api/v1/app/preferences`.
  The smoke also verifies a typed `INVALID_ARGUMENT` response for a bad
  preference value, while existing native tests cover the mutable key registry
  and range helpers. No new preference key was promoted for Release 1.

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- continues the curated preference model from `BUG-001` and `REST-002`
