---
id: FEAT-015
title: Broadband upload slot controller — budget-based slot cap + slow-slot reclamation
status: Open
priority: Major
category: feature
labels: [upload, broadband, performance, upload-queue, throttler, preferences]
milestone: ~
created: 2026-04-08
source: FEATURE-BROADBAND.md (FEAT_001 — stale branch, not yet on main)
---

## Summary

The stock upload controller scales slot count linearly with bandwidth using a hard-coded 25 KiB/s per-slot target (`UPLOAD_CLIENT_MAXDATARATE`). On a modern broadband link (50+ Mbit/s) this drives slot count toward 100, filling the pipe by accumulation rather than by keeping a small set of strong slots. This feature replaces that model with a budget-based controller: a configurable steady-state slot target, per-slot rate derived from actual upload budget, and proactive slow-slot reclamation.

**Status:** Full design exists in `docs/FEATURE-BROADBAND.md`. Implementation was done on the stale experimental branch (`archive/v0.72a-experimental-clean-provisional-20260404`) and never merged to main. Must be re-implemented on top of current main.

## The Problem (stock v0.72a behavior)

`UploadQueue.cpp:401-406` — slot count formula:
```cpp
// 4 slots or more - linear growth by 1 KiB/s steps, cap off at UPLOAD_CLIENT_MAXDATARATE
nResult = min(UPLOAD_CLIENT_MAXDATARATE, nOpenSlots * 1024);
```

`Opcodes.h:109-111`:
```cpp
#define UPLOAD_CLIENT_MAXDATARATE  (25*1024)   // 25 KiB/s per slot target
#define MAX_UP_CLIENTS_ALLOWED     100
```

On a 50 Mbit/s (~6100 KiB/s) uplink:
- target per slot: 25 KiB/s
- implied slot count: 6100 / 25 = 244 → capped at 100
- result: 100 slots all transferring at ~60 KiB/s each, no weak-slot retirement

A modern link works better with 12 strong slots at ~500 KiB/s each.

## New Controller Design

### Preferences (7 new hidden keys)

| Key | Type | Default | Meaning |
|-----|------|---------|---------|
| `BBMaxUpClientsAllowed` | int | 12 | Steady-state slot target (soft cap) |
| `BBSessionMaxTrans` | uint64 | `SESSIONMAXTRANS` | Session transfer limit (0=off, 1–100=% of file size, >100=absolute bytes) |
| `BBSessionMaxTime` | uint64 | `SESSIONMAXTIME` | Session time limit in seconds (0=off) |
| `BBBoostLowRatioFiles` | float | 0 | All-time ratio threshold for queue score bonus (0=off) |
| `BBBoostLowRatioFilesBy` | float | 0 | Additive queue score bonus when ratio threshold matches |
| `BBDeboostLowIDs` | int | 0 | Divide LowID queue score by this value (0/1=off) |

Exposed in **`Preferences > Tweaks > Broadband`** page with friendly editor labels.

### Effective upload budget

```cpp
uint32 effectiveBudget = min(GetMaxGraphUploadRate(true), GetMaxUpload());  // KiB/s
```

Falls back to legacy 25 KiB/s target if no real capacity configured.

### Per-slot target

```cpp
uint32 targetPerSlot = max(3u, effectiveBudget / BBMaxUpClientsAllowed);  // KiB/s floor 3
```

Existing 75% admission threshold applies to `targetPerSlot`.

### Slot admission (replaces `UploadQueue.cpp` slot-count logic)

- Fill freely while upload budget is underfilled
- Stop opening new slots once upload is satisfying the effective budget, even if below `BBMaxUpClientsAllowed`
- `MAX_UP_CLIENTS_ALLOWED = 100` kept as absolute ceiling only
- Temporary overflow: `ceil(softMaxSlots / 6)` extra slots allowed when:
  - queue is non-empty
  - upload underfilled by `max(targetPerSlot / 2, effectiveBudget * 5%)` 
  - underfill persists ≥ 2 seconds
  - throttler reported wanting another productive slot

### Slow/stuck slot reclamation (`UpdownClient.h` + `UploadClient.cpp`)

New state per `CUpDownClient`:

```cpp
DWORD  m_dwSlowUploadStart;    // when slow-rate accumulation started
float  m_fSlowAccumSec;        // accumulated seconds below threshold
bool   m_bInCooldown;          // true during post-eviction zero-score window
DWORD  m_dwCooldownEnd;        // when cooldown ends
```

Slow threshold: smoothed upload rate < `targetPerSlot / 3`

Eviction triggers (only while queue non-empty AND at/above soft cap AND underfilled):
- `m_fSlowAccumSec >= 15` seconds below slow threshold
- `m_fSlowAccumSec >= 3` seconds at exactly 0 upload rate

Evicted clients are requeued immediately (protocol compat) but queue score held at 0 for one slow-eviction window (`Cooldown` column).

Good samples reduce `m_fSlowAccumSec`. Neutral periods freeze timers.

### Session rotation overrides

Replace `SESSIONMAXTRANS`/`SESSIONMAXTIME` checks in upload slot logic with `BBSessionMaxTrans`/`BBSessionMaxTime`:
- `BBSessionMaxTrans == 0`: no transfer-based rotation
- `BBSessionMaxTrans 1–100`: `% of current file size`
- `BBSessionMaxTrans > 100`: absolute byte limit

### Socket buffer / disk prefetch scaling

Replace fixed `75 KiB/s` / `100 KiB/s` thresholds in `UploadDiskIOThread.cpp`:
- Large socket send buffer: enable when slot rate ≥ `targetPerSlot / 2`
- Disk prefetch: 1 → 3 → 5 blocks based on rate relative to `targetPerSlot`

## Ratio Methods (prerequisite — borrow from eMuleAI)

Add to `KnownFile.h` (eMuleAI already has these):

```cpp
double GetRatio() const {
    const uint64 fileSize = static_cast<uint64>(GetFileSize());
    return fileSize > 0 ? static_cast<double>(statistic.GetTransferred()) / static_cast<double>(fileSize) : 0.0;
}
double GetAllTimeRatio() const {
    const uint64 fileSize = static_cast<uint64>(GetFileSize());
    return fileSize > 0 ? static_cast<double>(statistic.GetAllTimeTransferred()) / static_cast<double>(fileSize) : 0.0;
}
```

These feed both the UI columns and the `BBBoostLowRatioFiles` queue scoring.

## UI Columns

Add to shared files, upload list, and queue list:

| Column | Source | Location |
|--------|--------|---------|
| `All-Time Ratio` | `GetAllTimeRatio()` — all-time transferred / file size | Shared, Upload, Queue |
| `Session Ratio` | `GetRatio()` — session transferred / file size | Shared, Upload, Queue |
| `Cooldown` | remaining slow-eviction suppression seconds | Upload, Queue |

## Files to Modify

| File | Change |
|------|--------|
| `Preferences.h/cpp` | 6 new BB* preference keys with load/save/defaults |
| `Opcodes.h` | No change to existing constants (BB* are separate) |
| `UploadQueue.h/cpp` | Replace slot-count formula; add budget/target computation; add `BBBoostLowRatioFiles` queue scoring |
| `UploadBandwidthThrottler.h/cpp` | Replace `UPLOAD_CLIENT_MAXDATARATE` guard with `targetPerSlot` |
| `UpdownClient.h` | Add slow-tracking members: `m_dwSlowUploadStart`, `m_fSlowAccumSec`, `m_bInCooldown`, `m_dwCooldownEnd` |
| `UploadClient.cpp` | Slow/stuck detection + eviction logic; cooldown queue-score zero |
| `UploadDiskIOThread.cpp` | Replace fixed buffer/prefetch thresholds with `targetPerSlot`-based scaling |
| `KnownFile.h` | Add `GetRatio()` / `GetAllTimeRatio()` |
| `UploadListCtrl.cpp` | All-Time Ratio, Session Ratio, Cooldown columns |
| `QueueListCtrl.cpp` | All-Time Ratio, Session Ratio, Cooldown columns |
| `SharedFilesCtrl.cpp` | All-Time Ratio, Session Ratio columns |
| New: `PPgBroadband.h/cpp` | `Preferences > Tweaks > Broadband` page |
| `PreferencesDlg.cpp` | Register `PPgBroadband` page |

## Implementation Order

1. `KnownFile.h` — add `GetRatio()` / `GetAllTimeRatio()`
2. `Preferences.h/cpp` — add all 6 BB* keys
3. `UploadQueue.cpp` — replace slot-count formula with budget-based controller
4. `UploadBandwidthThrottler.cpp` — replace UPLOAD_CLIENT_MAXDATARATE guard
5. `UpdownClient.h` / `UploadClient.cpp` — slow-slot tracking and eviction
6. `UploadDiskIOThread.cpp` — buffer/prefetch scaling
7. Session rotation overrides
8. UI columns (Ratio, Cooldown)
9. `PPgBroadband` preferences page

## Acceptance Criteria

- [ ] `BBMaxUpClientsAllowed=12` holds slot count near 12 on a 50 Mbit/s link (does not grow to 100)
- [ ] Slow uploaders (< `targetPerSlot / 3` for 15 s) are evicted and enter cooldown
- [ ] Zero-rate slots evicted after 3 s
- [ ] Cooldown prevents immediate slot re-entry; column shows remaining time
- [ ] `BBBoostLowRatioFiles` raises queue score for files with low all-time ratio
- [ ] `BBDeboostLowIDs` divides queue score for LowID clients by configured divisor
- [ ] `BBSessionMaxTrans` / `BBSessionMaxTime` override stock session rotation
- [ ] All-Time Ratio / Session Ratio columns sortable in Upload, Queue, Shared lists
- [ ] `Preferences > Tweaks > Broadband` page loads, saves, applies without restart
- [ ] `BBMaxUpClientsAllowed=0` falls back to legacy behavior (no regression)
- [ ] Upload works correctly when `GetMaxGraphUploadRate(true)` returns 0 (no real budget configured)

## Reference

Full design and rationale: `docs/FEATURE-BROADBAND.md`
Stale branch reference: `archive/v0.72a-experimental-clean-provisional-20260404`
eMuleAI Ratio columns: `analysis/emuleai/srchybrid/KnownFile.h:124-133`, `UploadListCtrl.cpp:355-362`
