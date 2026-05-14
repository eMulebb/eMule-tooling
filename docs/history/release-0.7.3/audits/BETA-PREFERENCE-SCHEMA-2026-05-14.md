# Beta 0.7.3 Preference Schema Audit

Date: 2026-05-14

Scope: strong schema validation for preference persistence, Preferences UI
source bindings, REST mutable preference bindings, and resource/dialog
references.

## Result

The schema layer now sits above the FEAT-060 raw inventory:

- raw inventory: 420 `Preferences.cpp` `CIni` key references;
- strong schema: 595 section-qualified/runtime entries;
- UI bindings: 800 `PPg*.cpp` `thePrefs` source bindings;
- REST bindings: all 15 native mutable preference fields.

The schema intentionally splits concrete storage identity by file, section, and
key. This prevents same-name keys in different sections, such as app `Port` and
WebServer `Port`, from hiding behind one raw inventory row.

## Enforced Checks

- schema manifest must match source-generated schema;
- every raw inventory storage entry must be represented;
- concrete `(storageFile, section, key)` tuples must be unique;
- every REST mutable preference field must map to one schema owner;
- every UI binding must point to existing schema entries and resource IDs;
- direct UI bindings must not duplicate owner mappings.

## Runtime Impact

No runtime behavior changed. The work adds test-harness schema validation only.
Persisted preference keys, defaults, migrations, and REST public field names are
unchanged.

Fresh final proof and package hashes remain owned by `CI-035`.
