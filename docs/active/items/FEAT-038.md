---
id: FEAT-038
title: Shared-files watcher and live recursive share sync
status: Done
priority: Minor
category: feature
labels: [shared-files, watcher, filesystem, auto-share, live-sync, performance]
milestone: ~
created: 2026-04-20
updated: 2026-04-26
source: eMuleAI release notes; current `main` revalidation
---

## Summary

Current `main` now has monitored shared-root support for live shared-folder
sync. This closes the watcher/live recursive share-sync feature surface that
was originally opened from the eMuleAI feature comparison.

This item is separate from `FEAT-034`. `FEAT-038` covers live watcher-driven
shared-root synchronization. `FEAT-034` still tracks blocking filesystem I/O and
manual reload/hash-drain hardening.

## Landed Scope

Current `eMule-main` contains:

- app-level shared-directory monitor startup and watcher loop
- persisted monitored-root state through `shareddir.monitored.dat`
- Shared Directories context-menu commands to add/remove monitored roots
- `UM_MONITORED_SHARED_DIR_UPDATE` UI handoff to the Shared Files window
- catch-up/journal handling for monitored roots after startup or missed events
- overlap guards so monitored roots are not nested ambiguously

Relevant current-main evidence includes:

- `srchybrid\Emule.cpp` / `Emule.h`
  - `StartSharedDirectoryMonitor()`
  - monitored root watcher state
  - catch-up and reconciliation helpers
- `srchybrid\Preferences.cpp` / `Preferences.h`
  - monitored shared-root persistence
- `srchybrid\SharedDirsTreeCtrl.cpp`
  - `MP_SHAREDIRMONITOR` menu action
  - add/remove monitored shared-directory commands
- `srchybrid\SharedFilesWnd.cpp`
  - `OnMonitoredSharedDirectoryUpdate(...)`

The implementation landed through the shared-directory work on `main`,
including:

- `138f577` - add monitored shared subtree refresh
- `60b3b44` - switch monitored shared refresh to watchers

## Comparison Notes

eMuleAI has a different watcher implementation and a broader AutoShareSubdirs
feature shape. The current branch took the narrower stock-friendly form:
monitored roots are explicit, persisted, and integrated into the existing
Shared Directories and Shared Files UI instead of importing the whole eMuleAI
shared-files subsystem.

## Remaining Follow-Up

No follow-up remains under this item.

Related but separate work remains under:

- `FEAT-034` - blocking filesystem I/O during shared hashing/reload
- `BUG-031` - transient shared-file hashing open failures

## Acceptance Criteria

- [x] shared-folder adds/removes/renames are detected without a full manual
      reload in the monitored-root path
- [x] recursive shared-root behavior is explicit and persisted
- [x] watcher events are handed off through bounded app/UI messages
- [x] fallback/reconciliation handles startup catch-up or missed confidence
      cases
- [x] uploads and share-state accounting are updated through the existing
      shared-files state machinery
