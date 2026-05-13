---
id: FEAT-023
title: Broadband queue scoring and ratio/cooldown UI extras
status: Done
priority: Minor
category: feature
labels: [upload, broadband, scoring, ui, seeding]
milestone: ~
created: 2026-04-11
source: `main` commit `5470d69` (`Add FEAT-023 queue scoring and score breakdown UI`)
---

## Summary

This feature is merged to `main`.

Mainline commit:

- `5470d69` — `Add FEAT-023 queue scoring and score breakdown UI`

These queue-scoring and UI extras remain intentionally separate from FEAT-015, but they
are no longer backlog work.

Detailed baseline review of the current queue-scoring path remains captured in `REF-031`.

**Mainline status:** landed on `main`.

The branch keeps the inherited stock/community admission-vs-selection split,
keeps cooldown as a hard effective-score suppression to `0`, keeps the LowID
divisor in the effective score path, and restores stale-branch low-ratio bonus
semantics by applying the bonus inside the float score pipeline before the
LowID divisor, old-client penalty, and final truncation.

## Current Branch Extras

- `LowRatioBoostEnabled`, `LowRatioThreshold`, and `LowRatioScoreBonus` add a
  low-ratio queue-score bonus for files with low all-time upload ratio
- `LowIDScoreDivisor` reduces queue score for LowID clients
- `All-Time Ratio` / `Session Ratio` columns are shown in shared, upload, and
  queue views
- `Cooldown` column is shown in upload and queue views
- low-ratio preference also affects the published shared-file ordering logic

## Why This Is Separate From FEAT-015

FEAT-015 is now the slot-allocation story:

- fixed upload-slot cap
- finite upload budget
- underfill-driven weak-slot recycle
- warm-up / slow / zero / cooldown timing
- friend-slot exception
- collection correctness guard

The items here are different in kind:

- they tune queue score rather than slot count
- they expose extra state in UI lists
- they are not required for the fixed-cap broadband uploader to work correctly

## Implemented FEAT-023 Decision

### Score semantics

- keep the stock/community score core:
  - waiting-time or capped download-session base
  - credit multiplier
  - file-priority multiplier
  - legacy old-client penalty
- keep cooldown as a hard effective-score suppression to `0`
- keep `LowIDScoreDivisor` in the effective full-score path
- restore stale broadband low-ratio semantics:
  - apply the low-ratio bonus before the LowID divisor
  - apply the low-ratio bonus before the old-client penalty
  - apply the low-ratio bonus before final float-to-integer truncation

### Intentionally unchanged inherited behavior

- soft-queue-limit admission still uses `GetCombinedFilePrioAndCredit()`
- next uploader selection still uses effective `GetScore(false)`
- queue rank still uses effective `GetScore(false)`
- max-score cache still uses `GetScore(true, false)`

### Desktop UI surfaces

- queue list now exposes:
  - base score
  - effective score
  - a modifiers column for cooldown / LowID divisor / low-ratio bonus state
- upload list now exposes a compact effective-score column
- client detail dialog now exposes:
  - base score
  - effective score
  - low-ratio bonus
  - LowID divisor
  - cooldown state
- Broadband Tweaks labels now reflect the implemented semantics directly:
  - low-ratio settings refer to queue/effective score
  - LowID divisor is labeled as an effective-score divisor
  - cooldown is labeled as effective-score suppression duration

Web UI and queue protocol behavior remain out of scope for this feature branch.

## Acceptance Criteria

- [x] low-ratio score knobs are documented as separate from FEAT-015 slot allocation
- [x] ratio/cooldown UI columns are documented as separate from FEAT-015 slot allocation
- [x] future cleanup can remove, keep, or retune these extras without reopening FEAT-015
