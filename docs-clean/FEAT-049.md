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
