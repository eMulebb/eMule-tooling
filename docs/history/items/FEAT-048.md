---
id: FEAT-048
title: REST upload queue control completeness
status: Passed
priority: Minor
category: feature
labels: [rest, uploads, queue, controller]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Audit the upload and upload-queue REST surface against controller workflows and
add only missing release-critical controls.

## Beta 0.7.3 Classification

**Release Candidate.** Audit and live-smoke existing upload controls first.
Only add operations that aMuTorrent or the release live-E2E lane actually
needs; unsupported actions should return typed errors.

## Execution Plan

Historical release context: [Beta 0.7.3 REST and Arr execution plan](../../history/release-0.7.3/RELEASE-0.7.3-REST-ARR-EXECUTION-PLAN.md).

## Acceptance Criteria

- [x] existing upload list, queue list, remove, and release-slot behavior is
      live-smoked
- [x] client selectors are documented and tested for hash and `ip` plus `port`
      inputs
- [x] unsupported queue operations return typed errors instead of silent no-op
      behavior
- [x] any new action preserves current upload scheduling semantics

## Progress

- 2026-05-07: Revalidated the existing upload surface for Release 1. Live REST
  smoke covers upload list, upload queue list, remove, release-slot, and
  malformed queue selectors. Native route seams now cover both lowercase
  user-hash selectors and `ip:port` selectors for uploads and upload-queue
  operations, including invalid port bounds.
- 2026-05-07: Added live-smoke and native route coverage proving unsupported
  upload and upload-queue operations return typed `NOT_FOUND` REST errors with
  the stable error envelope. No new upload scheduling action was promoted for
  Release 1.

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- complements upload list stale-row hardening already landed under `BUG-042`
      and `BUG-066`
