# Review 2026-04-14 — Main Bug-Only Pass (Deeper Follow-Up)

## Scope

Second focused pass on fresh concrete bugs in current `eMule-main`.

This follow-up stayed narrow on live crash/corruption/runtime-failure behavior
and intentionally excluded cleanup-only debt, refactor suggestions, and broad
speculative code-style review.

## New Confirmed Bugs

### BUG-026 — search tab teardown use-after-free / crash window

- current `main` deletes `CSearchFile` result objects before the list control
  drops the raw row pointers that reference them
- current `main` also deletes `SSearchParams` tab payloads before
  `searchselect.DeleteAllItems()` clears the tabs on `DeleteAllSearches()`
- `emuleai` contains the corrected ordering for both the active-results path and
  the delete-all tab-parameter path

See: [BUG-026](../items/BUG-026.md)

### BUG-027 — IP filter update can remove the live filter on failed promotion

- `PromoteIpFilterFile()` deletes the live target before replacement promotion
  succeeds
- ZIP/RAR/GZip/plain-file callers all treat promotion as success even when the
  helper fails, either by discarding the return or relying on `VERIFY(...)`
- this can leave `ipfilter.dat` missing and reload the client into an empty
  filter set after a failed update attempt

See: [BUG-027](../items/BUG-027.md)

## Revalidated But Not Promoted In This Follow-Up

- shared-files tree and counter-update paths were re-read against sibling trees,
  but this pass did not confirm another current-tree crash/corruption bug with
  enough direct evidence to promote a new backlog item
- several additional Win32/CRT diagnostic mismatches still exist outside
  `BUG-025`, but they were not promoted again here because they are secondary
  siblings of the already-documented logging bug class

## Outcome

This deeper follow-up added two new concrete bug items to `docs/active/INDEX.md`:

- [BUG-026](../items/BUG-026.md)
- [BUG-027](../items/BUG-027.md)
