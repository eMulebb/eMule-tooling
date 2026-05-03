---
id: FEAT-052
title: Main-shell keyboard shortcuts and mnemonic audit
status: Done
priority: Minor
category: feature
labels: [ui, keyboard, shortcuts, mnemonics]
milestone: broadband-release
created: 2026-05-03
source: user-directed keyboard shortcut audit
---

## Summary

Reserve direct clean-exit and floating-menu shortcuts for the native main shell
using the same hidden mnemonic style as the original hotmenu accelerator. The
Search parameter bar also has a first local mnemonic pass that avoids current
main-shell toolbar and hotmenu letters.

## Acceptance Criteria

- [x] `Alt+X` exits through the normal clean shutdown path
- [x] exit shortcut respects the existing Prompt on exit setting
- [x] `Alt+U` opens the existing floating hotmenu
- [x] modal dialogs keep their normal local keyboard handling
- [x] shortcut ownership is documented with `EMULE_KEYBOARD_SHORTCUT`
- [x] focused native tests cover shortcut classification and modal suppression
- [x] Search `Alt+N` focuses the Name textbox while Search is active
- [x] Search core mnemonics avoid reserved main-shell toolbar letters

## Implementation Notes

- Do not edit localized resources in the first pass.
- English Search parameter strings now use Search-specific resource IDs for
  mnemonic-bearing labels and buttons.
- Do not sweep unrelated mnemonic collisions; document them for later review.
- `Ctrl+Q` and `Ctrl+M` are intentionally unbound in this slice.
- Remaining follow-up: full dialog/preference mnemonic collision audit across
  the app, including localized resources, is still outside this slice.
