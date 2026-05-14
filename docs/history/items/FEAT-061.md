---
id: FEAT-061
title: Strong preference schema validation
status: Done
priority: Minor
category: feature
labels: [beta-0.7.3, preferences, schema, validation, ui]
milestone: Beta 0.7.3
created: 2026-05-14
closed: 2026-05-14
source: operator request for bulletproof preference schema validation
---

# FEAT-061 - Strong Preference Schema Validation

## Summary

The preference contract now has a generated strong schema on top of the raw
INI inventory. It splits same-name keys by section, records REST bindings,
records Preferences UI source bindings, and fails Python tests on schema drift
or duplicate concrete storage keys.

## Outcome

- Added `preference-schema.v1.json` with 595 schema entries and 800 UI
  bindings.
- Split same-name storage keys such as `Port` and `BindAddr` by section so
  duplicate storage ownership can be checked.
- Added source parsers for preference dialogs, `resource.h`, `emule.rc`, REST
  mutable preference metadata, and `PPg*.cpp` preference touches.
- Added Python tests that fail when schema generation drifts, concrete storage
  keys duplicate, REST fields drift, UI bindings point to missing resources, or
  direct UI binding ownership duplicates.
- Kept runtime behavior, persisted keys, defaults, and REST field names
  unchanged.

## Validation

- `python -m emule_workspace test python --workspace-root ..\.. -q` passed
  with 428 tests.

## Implementation Commits

- Build tests: `71645e2` (`FEAT-061 add strong preference schema validation`)
- Tooling: recorded by the commit that adds this item.
