---
id: FEAT-048
title: REST upload queue control completeness
status: Open
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

## Release 1.0 Classification

**Release Candidate.** Audit and live-smoke existing upload controls first.
Only add operations that aMuTorrent or the release live-E2E lane actually
needs; unsupported actions should return typed errors.

## Acceptance Criteria

- [ ] existing upload list, queue list, remove, and release-slot behavior is
      live-smoked
- [ ] client selectors are documented and tested for hash and `ip` plus `port`
      inputs
- [ ] unsupported queue operations return typed errors instead of silent no-op
      behavior
- [ ] any new action preserves current upload scheduling semantics

## Relationship To Other Items

- updates `CI-014` and `CI-015`
- complements upload list stale-row hardening already landed under `BUG-042`
      and `BUG-066`
