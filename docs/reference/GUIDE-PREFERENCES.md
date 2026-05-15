# Preferences Guide

This guide explains preferences from a user/operator perspective. Architecture
details live in [Preference Architecture](../architecture/ARCH-PREFERENCES.md)
and the [Preference Surface Matrix](../architecture/PREFERENCE-SURFACE-MATRIX.md).

## Storage Model

eMule BB uses classic eMule storage plus BB-specific `preferences.ini` keys.
Settings can be read or written from:

- Preferences UI
- Tools menu actions
- REST mutable preference endpoints
- direct config-file edits for selected files
- first-run/default seeding
- migration/reset logic

The app validates preference inventory and schema in tests so storage keys,
UI bindings, and REST bindings do not drift silently.

## Persistence

Normal preference changes persist through the app's existing save path. Some
Tools actions, such as quick speed throttles and view presets, also persist
because they update the same preference/list-control storage as the UI.

Use Tools > Save Preferences Now after direct or high-risk maintenance if you
want an explicit save point.

## Important Preference Areas

Connection:

- TCP/UDP ports
- auto-connect
- reconnect
- UPnP
- max connections
- bind interface/address
- startup bind blocking

Security:

- IP filter enablement
- filter level
- IP filter update URL and update period
- protocol obfuscation options
- search spam filter

Directories:

- incoming directory
- temp directory
- shared roots
- monitored share roots

Display:

- tray behavior
- minimize-to-tray
- always show tray icon
- table layouts and view presets

Tweaks:

- broadband upload policy
- automatic broadband IO buffers
- diagnostics/logging
- network timing controls
- archive preview and media metadata settings

WebServer/REST:

- listener enablement
- bind address
- port
- API key
- legacy template web server enablement

## Defaults

Missing or empty config files can be created with defaults where appropriate.
Examples include bootstrap URL lists and selected sidecar files. Existing
non-empty files are preserved.

Default values should be conservative:

- REST is preferred for controllers.
- Legacy web templates are explicit opt-in.
- IP filtering applies only when enabled.
- Network bind fallback is visible rather than silent when configured targets fail.
- Broadband IO and upload defaults favor stable modern operation.

## Schema And Reset Behavior

eMule BB uses a preference schema marker to apply selected one-time migrations
without relying on app version strings. This supports resetting old table
layouts or other BB-specific preferences on first BB run while leaving unrelated
user settings intact.

The schema marker is stored as `BBPreferenceSchema`.

## Direct Edits

Direct edits are useful for recovery and bulk changes. They are not always live.
After editing:

- reload filters/rules when a reload action exists
- save preferences from the UI for normal preference changes
- restart for startup-only settings such as some bind or WebServer changes

Avoid editing binary files such as `preferences.dat` directly.

## REST Preferences

REST exposes a curated mutable subset, not every internal preference. This is
intentional. REST settings must be stable, validated, and useful to trusted
controllers. The OpenAPI contract is authoritative for route and field names.

## Troubleshooting Preferences

If settings behave unexpectedly:

1. Check whether the setting is UI-only, REST-exposed, or startup-only.
2. Confirm the correct config file and section.
3. Check whether a first-run migration reset old UI state.
4. Use the diagnostic snapshot to inspect effective runtime state.
5. Avoid changing multiple related preferences before observing behavior.
