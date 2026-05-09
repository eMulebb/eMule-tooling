---
id: FEAT-055
title: Release 1.0.1 improvement triage lane
status: Open
priority: Minor
category: feature
labels: [r1.0.1, improvements, triage, release-follow-up]
milestone: post-R-1.0.1
created: 2026-05-09
source: R-1.0.1 community parity review
---

## Summary

Collect improvements discovered during the R-1.0.1 parity audit without
expanding the patch-release blocking scope. This item is intentionally not a
release blocker unless a listed improvement is promoted into a bug or CI gate.

## Candidate Improvements

- one-command R-1.0.1 proof orchestration through `workspace.ps1`
- automated changed-surface grouping for future release audits
- controller compatibility matrix for native REST, qBit, Torznab, Arr, and
  aMuTorrent consumers
- compact operator summary for live E2E artifacts
- lightweight UI smoke coverage for representative language/resource loads
- packaging manifest diff report against the previous release asset
- clearer release-note separation between stock parity, Broadband features, and
  intentionally frozen legacy areas

## Acceptance Criteria

- [ ] Improvements found during CI-022 through CI-031 are listed here or
      promoted to specific items.
- [ ] Each improvement is classified as blocker, next-patch, future, or
      rejected.
- [ ] No improvement blocks R-1.0.1 unless it fixes a confirmed regression,
      missing advertised behavior, or release-proof gap.
- [ ] Follow-up items are created for approved post-R-1.0.1 work.

## Validation

- Review output from
  [REVIEW-2026-05-09-release-1.0.1-community-parity](../reviews/REVIEW-2026-05-09-release-1.0.1-community-parity.md).
- Final R-1.0.1 release decision in [RELEASE-1.0.1](../RELEASE-1.0.1.md).
