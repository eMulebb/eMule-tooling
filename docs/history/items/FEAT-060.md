---
id: FEAT-060
title: Preference inventory, mapping, clamp, and persistence audit
status: Done
priority: Minor
category: feature
labels: [beta-0.7.3, preferences, rest-api, persistence, audit]
milestone: Beta 0.7.3
created: 2026-05-14
closed: 2026-05-14
source: operator preference persistence hardening request
---

# FEAT-060 - Preference Inventory, Mapping, Clamp, And Persistence Audit

## Summary

The preferences persistence surface now has a source-driven machine-readable
inventory and drift tests. The native REST mutable preference surface also uses
one canonical metadata table for field names, value kinds, error text, and
validators.

## Outcome

- Added `preference-inventory.v1.json` with all `Preferences.cpp` `CIni`
  key references observed by the source audit.
- Added Python drift tests that fail when `Preferences.cpp` adds, removes, or
  changes an INI key without updating the inventory.
- Classified non-round-trip keys explicitly:
  `DownSessionCompletedFiles`, `VideoPreviewThumbnails`,
  `LogErrorColor`, `LogWarningColor`, `LogSuccessColor`,
  `UpdateQueueListPref`, and dynamic key families.
- Centralized native REST mutable preference metadata so parser, route schema,
  and request validation share the same field list.
- Kept persisted key names, defaults, and runtime behavior unchanged.

## Acceptance

- [x] Every `Preferences.cpp` `CIni` key reference is represented in a
      machine-readable inventory.
- [x] Read/write asymmetries are classified instead of treated as silent drift.
- [x] REST mutable preference fields are covered by one metadata table.
- [x] Existing REST field names and value ranges remain unchanged.

## Validation

- `python -m emule_workspace test native --config Release --platform x64 --suite-name web_api --build-output-mode ErrorsOnly` passed.
- `python -m emule_workspace test python --workspace-root ..\.. -q` passed with
  422 tests.

## Implementation Commits

- App: `cff6300` (`FEAT-060 centralize REST preference metadata`)
- Build tests: `ac2ffa5` (`FEAT-060 guard preference inventory`)
- Tooling: recorded by the commit that adds this item.
