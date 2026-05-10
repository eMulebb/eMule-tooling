---
id: FEAT-055
title: Beta 0.7.3 improvement triage lane
status: Done
priority: Minor
category: feature
labels: [beta-0.7.3, improvements, triage, release-follow-up]
milestone: post-beta-0.7.3
created: 2026-05-09
source: Beta 0.7.3 community parity review
---

## Summary

Collect improvements discovered during the Beta 0.7.3 parity audit without
expanding the patch-release blocking scope. This item is intentionally not a
release blocker unless a listed improvement is promoted into a bug or CI gate.

## Candidate Improvements

- one-command Beta 0.7.3 proof orchestration through `python -m emule_workspace`
- automated changed-surface grouping for future release audits
- controller compatibility matrix for native REST, qBit, Torznab, Arr, and
  aMuTorrent consumers
- compact operator summary for live E2E artifacts
- lightweight UI smoke coverage for representative language/resource loads
- packaging manifest diff report against the previous release asset
- clearer release-note separation between stock parity, Broadband features, and
  intentionally frozen legacy areas

## Triage Decision

| Improvement | Classification | Beta 0.7.3 decision | Follow-up |
|-------------|----------------|------------------|-----------|
| one-command Beta 0.7.3 proof orchestration through `python -m emule_workspace` | next-patch | non-blocking; current gates have explicit command evidence | [FEAT-056](FEAT-056.md) |
| automated changed-surface grouping for future release audits | future | non-blocking; CI-022 ledger is complete for Beta 0.7.3 | [FEAT-056](FEAT-056.md) |
| controller compatibility matrix for native REST, qBit, Torznab, Arr, and aMuTorrent consumers | next-patch | non-blocking; CI-024 and CI-025 carry current release proof | [FEAT-056](FEAT-056.md) |
| compact operator summary for live E2E artifacts | next-patch | non-blocking; current artifacts are detailed enough for release decisions | [FEAT-056](FEAT-056.md) |
| lightweight UI smoke coverage for representative language/resource loads | future | non-blocking; CI-030 and CI-031 prove current language/resource build and package viability | [FEAT-056](FEAT-056.md) |
| packaging manifest diff report against the previous release asset | next-patch | non-blocking; CI-031 includes manual package and manifest inspection | [FEAT-056](FEAT-056.md) |
| clearer release-note separation between stock parity, Broadband features, and intentionally frozen legacy areas | next-patch | non-blocking for the code/package gate; should inform publication notes | [FEAT-056](FEAT-056.md) |

No candidate is a Beta 0.7.3 blocker. No candidate fixes a confirmed regression,
missing advertised behavior, or release-proof gap that remains open after
CI-022 through CI-032, REF-037, and this triage pass.

## Acceptance Criteria

- [x] Improvements found during CI-022 through CI-031 are listed here or
      promoted to specific items.
- [x] Each improvement is classified as blocker, next-patch, future, or
      rejected.
- [x] No improvement blocks Beta 0.7.3 unless it fixes a confirmed regression,
      missing advertised behavior, or release-proof gap.
- [x] Follow-up items are created for approved post-beta-0.7.3 work.

## Completion Evidence

- Approved follow-up item:
  [FEAT-056](FEAT-056.md).
- Release gate decision: all improvements are next-patch or future scope; none
  blocks `emule-bb-v1.0.1`.
- Validation:
  - CI-022 through CI-032 are closed.
  - REF-037 is closed.
  - `python -m emule_workspace validate` passed after the active release docs update.

## Validation

- Review output from
  [REVIEW-2026-05-09-release-0.7.3-community-parity](../reviews/REVIEW-2026-05-09-release-0.7.3-community-parity.md).
- Final Beta 0.7.3 release decision in [RELEASE-0.7.3](../RELEASE-0.7.3.md).
