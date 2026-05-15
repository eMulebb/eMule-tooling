# Preference Architecture

This document explains how the current `main` preference surface is organized
and why. It is not the exact key/default/range reference.

The canonical active preference matrix is
[`PREFERENCE-SURFACE-MATRIX.md`](PREFERENCE-SURFACE-MATRIX.md). Keep exact
active keys, defaults, UI behavior, persistence ranges, and REST exposure there
only.

## Scope

`preferences.ini` contains four different classes of data:

1. active user-facing and operator preferences
2. hidden/internal runtime preferences
3. retired legacy names that current main ignores
4. counters, statistics, categories, and UI layout state

Only the first two classes are active preference contracts. The matrix owns
their exact rows. This document owns the surrounding policy, compatibility
rationale, and summaries for non-preference state.

## Source Of Truth

Use these sources when changing preferences:

- `srchybrid/Preferences.cpp` for load/save behavior
- `srchybrid/Preferences.h` for defaults, getters, setters, and normalizers
- `srchybrid/PPg*.cpp` for Preferences dialog behavior
- `srchybrid/WebServerJson.cpp` and `srchybrid/WebApiSurfaceSeams.h` for REST
- `srchybrid/PreferenceIniMap.h` for non-stock section/key constants

Do not duplicate exact active preference rows in this file. If a default,
range, UI validator, section name, or REST field changes, update the matrix.

## INI Compatibility Policy

Current main preserves stock/community drop-in compatibility unless a cleanup is
explicitly chosen as a compatibility-breaking change.

- Do not move established stock keys to new sections.
- Prefer the established written casing for every key.
- Keep section/key lookup case-insensitive because both the Windows profile API
  path and current long-path file-backed INI path behave that way.
- Normalize direct INI values at load when existing code historically tolerated
  malformed values.
- Prefer explicit UI/REST validation for new user input instead of silently
  rewriting invalid values.

Current main writes canonical casing for the known case-only mismatches:
`StatsInterval`, `AutoCat`, `UpOverheadTotal`, and
`UpOverheadTotalPackets`.

## Encoding And API Policy

`preferences.ini` is handled through the native wide INI/profile path and the
workspace long-path file-backed path. Startup normalizes supported legacy input
into the current Unicode profile-file representation.

Do not reintroduce special UTF-8 string helpers for individual preferences.
String reads and writes should flow through the shared INI/profile layer.

## Section Policy

Established stock keys stay where stock expects them. New branch-owned groups
may use dedicated sections when that improves readability without breaking
existing stock placement.

Current dedicated sections used by branch-owned or already-sectioned behavior:

- `[FileCompletion]`: file-completion command enable/program/arguments
- `[UploadPolicy]`: broadband upload/session policy knobs
- `[UPnP]`: UPnP enable, close-on-exit, and backend mode
- `[WebServer]`: WebServer credentials, binding, ports, HTTPS, upload limit,
  allowed IPs, and API key
- `[Proxy]`: proxy settings
- `[Statistics]`: statistics display state
- `[PerfLog]`: performance logging configuration

Branch-added geolocation and IP-filter updater keys currently remain in
`[eMule]` to stay close to the surrounding stock security/advanced preference
area and avoid an extra update-only section split.

## REST Policy

`GET /api/v1/app/preferences` and `PATCH /api/v1/app/preferences` expose a
curated controller subset, not `preferences.ini`.

- REST writes must use the same setters/normalizers as UI/persistence.
- REST PATCH must reject unsupported names and out-of-range values explicitly.
- Adding a REST field requires updating OpenAPI, `WebApiSurfaceSeams`, tests,
  and the exact matrix.
- WebServer HTML form preferences are not part of this REST preference surface
  unless intentionally added to the API.

## Retired INI Names

Retired keys remain documented so old INI files are understandable, but current
main does not read, write, migrate, or delete them unless a migration is
explicitly implemented.

Retired names currently tracked:

- `DownloadCapacity`, `UploadCapacityNew`, `UploadCapacity`
- `FileBufferSizePref`, `QueueSizePref`
- `MiniMule`, `AICHTrustEveryHash`
- `ResumeNextFromSameCat`, `AdjustNTFSDaylightFileTime`
- `SkipWANIPSetup`, `SkipWANPPPSetup`, `LastWorkingImplementation`,
  `DisableMiniUPNPLibImpl`, `DisableWinServImpl`
- `UDPReceiveBufferSize`, `BigSendBufferSize`, `UploadClientDataRate`

REST `uploadClientDataRate` is a derived controller input that updates upload
slots. It is not a same-named persisted INI preference.

## UI Defaults Outside `CPreferences`

Some defaults are supplied directly by UI code rather than a first-class
persisted `CPreferences` member:

- server.met URL: `https://upd.emule-security.org/server.met`
- nodes.dat URL: `https://upd.emule-security.org/nodes.dat`
- server.met URL history: `addresses.dat`, seeded only when missing or blank
  with `https://upd.emule-security.org/server.met` and
  `https://emuling.gitlab.io/server.met`
- IP filter URL history: `AC_IPFilterUpdateURLs.dat`, seeded only when blank;
  user-facing behavior is documented in
  [GUIDE-IP-FILTERS](../reference/GUIDE-IP-FILTERS.md)
- Kad bootstrap mode: load nodes from URL

If one of these becomes persisted, add it to the matrix at the same time.

## Non-Preference INI State

The following live in `preferences.ini`, but they are state, counters, or UI
records rather than preference contracts:

- transfer totals: `TotalDownloadedBytes`, `TotalUploadedBytes`, session
  success/failure counts, completed-file counts, and average durations
- protocol overhead counters: `DownOverhead*`, `UpOverhead*`
- client/source/port-family totals: `DownData_*`, `UpData_*`,
  `DownDataPort_*`, `UpDataPort_*`
- connection/server/share high-water marks: `Conn*`, `SrvrsMost*`,
  `SharedMost*`, `SharedLargest*`
- UI layout state: splitter positions, transfer panes, last selected panes,
  toolbar/skin presentation, fonts, colors, and statistics tree state
- category records: `Count`, `Title`, `Incoming`, `Comment`, `Color`,
  `a4afPriority`, `AutoCat`, `RegularExpression`,
  `AutoCatAsRegularExpression`, `Filter`, `FilterNegator`,
  `downloadInAlphabeticalOrder`, and `Care4All`

Keep these summarized here unless they become behavior knobs. Do not inflate the
active preference matrix with counter/state rows.

## Behavior Notes

These notes explain runtime meaning that is easy to miss from the matrix alone.

- Throughput limits are operative runtime caps. Broadband slot targeting uses
  `MaxUpload` as one bound on the effective upload budget.
- `MaxConnections`, `MaxHalfConnections`, and
  `MaxConnectionsPerFiveSeconds` are resource and churn guards, not priority
  controls.
- `ConnectionTimeout` is the shared TCP peer-connect timeout baseline, while
  `DownloadTimeout` governs silent download payload peers.
- `Serverlist`, `AddServersFromServer`, and `AddServersFromClient` are separate
  discovery surfaces with different trust implications.
- `Autoconnect` affects startup sequencing. Its default remains off.
- `NetworkED2K` and `NetworkKademlia` enable or disable whole network activity
  paths, not just UI visibility.
- `AutoBroadbandIO`, `FileBufferSize`, `FileBufferTimeLimit`, `CommitFiles`,
  and sparse/prealloc options are durability/performance tradeoffs.
- `MinFreeDiskSpaceConfig`, `MinFreeDiskSpaceTemp`, and
  `MinFreeDiskSpaceIncoming` are operational write-safety floors, not only UI
  warnings.
- Obfuscation settings are capability and policy switches:
  supported/requested/required are intentionally distinct.
- Message/captcha/source validation settings affect acceptance flow, not just
  presentation.
- Toolbar, taskbar, graph, and font settings often alter control creation or
  rendering behavior even when they look like cosmetic preferences.
- Broadband upload-policy settings affect queue scoring, slow-slot recycling,
  session rotation, and upload-slot target selection.
- Hidden maintenance knobs such as `KeepUnavailableFixedSharedDirs`,
  `PartiallyPurgeOldKnownFiles`, `RearrangeKadSearchKeywords`,
  `RestoreLastMainWndDlg`, and `RestoreLastLogPane` are still active runtime
  behavior switches when present in the matrix.

## Audit Discipline

When changing preferences:

1. Update code at the lowest layer where the rule is true.
2. Keep UI, INI load/save, REST, OpenAPI, tests, and the matrix aligned.
3. Preserve stock key placement unless the change is explicitly approved as a
   compatibility break.
4. For docs-only preference edits, manually cross-check
   `PREFERENCE-SURFACE-MATRIX.md` against `Preferences.cpp` before committing.
