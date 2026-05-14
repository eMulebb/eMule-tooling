---
id: FEAT-056
title: Add qBittorrent-style download shortcuts and batch menu actions
status: Done
priority: Minor
labels: [ui, keyboard, menus, downloads]
created: 2026-05-14
closed: 2026-05-14
---

# FEAT-056 - Add qBittorrent-Style Download Shortcuts And Batch Menu Actions

## Summary

Downloads gained additional keyboard-friendly actions modeled after common
power-user torrent clients while staying local to the Transfers download list.

## Outcome

- Added selected-download priority shortcuts for raise/lower and direct
  high/low priority.
- Added current-category batch pause, stop, and resume actions to the file menu.
- Added `Alt+O` as a main-shell Options mnemonic.
- Updated the keyboard shortcut reference and native shortcut seam coverage.

## Acceptance

- [x] Shortcuts are documented in `docs/reference/KEYBOARD-SHORTCUTS.md`.
- [x] Shortcut classification is covered by native seam tests.
- [x] Batch actions use the existing category status command path.
