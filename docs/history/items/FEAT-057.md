---
id: FEAT-057
title: Add qBittorrent-style download shortcuts and batch menu actions
status: Done
priority: Minor
labels: [ui, keyboard, menus, downloads]
created: 2026-05-14
closed: 2026-05-14
---

# FEAT-057 - Add qBittorrent-Style Download Shortcuts And Batch Menu Actions

## Summary

Downloads gained additional keyboard-friendly actions modeled after common
power-user torrent clients while staying local to the Transfers download list.

This record supersedes the duplicate historical `FEAT-056` item file that was
briefly created for this completed UI slice. The pushed implementation commit
messages still reference `FEAT-056`; those commits are left intact, and this
metadata correction preserves the active `FEAT-056` item for post-beta release
proof automation and operator evidence UX.

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

## Implementation Commits

- App: `201d2ad` (`FEAT-056 add qbit-style download shortcuts`)
- Tests: `b5e0735` (`FEAT-056 cover qbit-style download shortcuts`)
- Docs: `ce35476` (`FEAT-056 document keyboard menu parity`)
