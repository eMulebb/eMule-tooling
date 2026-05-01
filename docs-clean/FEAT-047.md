---
id: FEAT-047
title: REST search API completeness pass
status: Open
priority: Minor
category: feature
labels: [rest, search, amutorrent, live-wire]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Audit and fill release-critical search API gaps for aMuTorrent and other local
controllers.

## Acceptance Criteria

- [ ] aMuTorrent search views can render useful result rows without private
      adapter assumptions
- [ ] server, global, Kad, and automatic search methods remain explicit
- [ ] cancellation and missing-search behavior return stable typed errors
- [ ] paging or bounding behavior is documented if result sets are limited
- [ ] live coverage includes the release search corpus

## Relationship To Other Items

- backs `CI-013` and `CI-014`
- should not change default eD2K/Kad search semantics
