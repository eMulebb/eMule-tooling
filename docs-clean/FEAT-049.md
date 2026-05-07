---
id: FEAT-049
title: Curated REST preference expansion
status: Open
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

## Release 1.0 Classification

**Release Candidate.** Keep the first-release preference surface curated. Add
only settings required by aMuTorrent or release automation; risky debug,
compatibility, and protocol internals stay private.

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Acceptance Criteria

- [ ] missing aMuTorrent-relevant settings are identified by direct adapter/UI
      needs
- [ ] risky compatibility, debug, and protocol internals remain unexposed
- [ ] all mutable preferences round-trip through normal preference persistence
- [ ] bad values return typed REST errors
- [ ] native and live REST tests cover every new key

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- continues the curated preference model from `BUG-001` and `REST-002`
