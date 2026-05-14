---
id: FEAT-059
title: Move tray icon visibility preference next to minimize-to-tray
status: Done
priority: Minor
category: feature
labels: [beta-0.7.3, ui-polish, preferences, tray]
milestone: Beta 0.7.3
created: 2026-05-14
closed: 2026-05-14
source: operator preference organization request
---

# FEAT-059 - Move Tray Icon Visibility Preference Next To Minimize-To-Tray

## Summary

The `Always show tray icon` preference moved from the Tweaks tree to the
Display preferences page, directly under `Minimize to system tray`.

## Outcome

- Added `Always show tray icon` to Preferences > Display next to the
  minimize-to-tray setting.
- Removed the duplicate Tweaks tree entry so the setting has one canonical UI
  location.
- Kept the existing `AlwaysShowTrayIcon` persisted preference key and runtime
  tray visibility behavior.

## Acceptance

- [x] `Always show tray icon` is adjacent to `Minimize to system tray` in the
      Display preferences resource.
- [x] Tweaks no longer owns or displays the same setting.
- [x] Applying the Display page updates tray visibility when the setting
      changes.
- [x] No config migration or preference-key rename is required.

## Validation

- `git diff --check` passed.
- `python -m emule_workspace validate --config Release --platform x64 --build-output-mode ErrorsOnly` passed.
- `python -m emule_workspace build app --config Release --platform x64 --build-output-mode ErrorsOnly` passed.

## Implementation Commits

- App: `ded11e7` (`FEAT-059 move tray icon preference`)
- Tooling: recorded by the commit that adds this item.
