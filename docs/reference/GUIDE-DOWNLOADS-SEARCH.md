# Downloads And Search Guide

This guide covers search, download workflow, categories, filename handling,
transfer limits, and broadband upload behavior.

## Search Modes

eMule BB preserves native eMule search distinctions:

- Server search queries the current eD2K server.
- Global search uses the eD2K server network more broadly.
- Kad search uses decentralized Kad search.
- Automatic/controller search must map to one of the native search modes.

Use server search when a trusted server is enough, global search when wider
server coverage matters, and Kad when decentralized discovery is more useful.

Search result ceilings are configurable so modern sessions do not have to keep
old stock limits. eD2K expansion and Kad total/lifetime settings are persisted
preferences; exact keys and ranges are in [Preferences Guide](GUIDE-PREFERENCES.md).

## Search Result Quality

Search results can include bad names, misleading extensions, spam, or fake-file
signals. Treat the visible row as a candidate, not proof.

Check:

- filename agreement across sources
- suspicious extension/name combinations
- fake-file detector matches
- source count and source diversity
- comments and known metadata
- category destination and expected file type

Do not rely on one signal. File details and comments matter most for rare or
ambiguous files.

## Download Actions

Common actions:

- start, resume, pause, stop
- cancel with confirmation
- shifted cancel/delete paths for power-user no-confirm behavior
- open completed file
- open containing folder
- show details and comments
- copy ED2K links, names, paths, summaries, sizes, status, and progress
- change priority
- assign or move category

Keyboard details are in [Keyboard Shortcuts](KEYBOARD-SHORTCUTS.md).

## Categories

Categories are persistent workflow state. They affect organization, incoming
paths, filters, and controller expectations.

Good category practice:

- keep names short and stable
- avoid deleting categories that automation still uses
- move downloads intentionally before removing a category
- keep one default catch-all category
- use the category manager for normal edits and `Category.ini` only for careful
  maintenance

## Filename Cleanup

eMule BB can normalize download names on intake and completion. This is intended
to reduce obvious junk, not to erase identity.

Review before batch changes when:

- the filename becomes generic
- the extension does not match the expected type
- sources disagree
- fake/trust feedback is mixed
- the result came from a controller import rather than manual selection

Filename cleanup settings and threshold preferences are documented in
[Preferences Guide](GUIDE-PREFERENCES.md).

## Transfer Limits

Upload and download limits are finite runtime caps. eMule BB defaults are
modernized from older stock assumptions, but users should still set realistic
values for the current line.

Related controls:

- upload limit
- download limit
- max connections
- half-open/churn limits
- sources per file
- queue size
- file buffer size and time limit
- disk-space floors
- commit, sparse, and preallocation behavior

These settings are operational controls. Setting them too high can make network,
disk, or UI behavior worse even on a fast machine.

## Broadband Upload Policy

The broadband upload controller changes the old stock model where upload slot
count could grow heavily with available speed.

Released behavior:

- `MaxUploadClientsAllowed` is the normal upload-slot target.
- Slot decisions use a finite configured upload budget.
- Slow or zero-rate slots can be recycled after warm-up and grace periods.
- Cooldown prevents the same weak slot pattern from churning constantly.
- Collection uploads have an intentional compatibility exception.
- Low-ratio scoring can give selected clients a queue boost.
- Ratio and cooldown data can be shown in UI columns.

Practical tuning:

- set a finite upload limit first
- keep the slot target modest for broadband links
- let warm-up finish before judging a slot as weak
- use diagnostics if upload timer or disk IO pressure appears
- avoid unlimited experiments when diagnosing speed

The exact broadband preference keys live under `[UploadPolicy]` and are listed
in [Preferences Guide](GUIDE-PREFERENCES.md).

## Modern Defaults

Modern-limit work adjusted old conservative assumptions where release changes
landed:

- connection and churn defaults are less constrained
- per-client upload/socket behavior is better suited to faster lines
- disk buffering defaults support larger transfers
- source, queue, and search ceilings are more practical for current use
- selected timeouts and buffers are documented as tunable preferences

Existing profiles keep explicit stored values unless migration or normalization
rules say otherwise.

## File Details And Copy Workflows

Use details for:

- source/name comparison
- comments
- hashes and ED2K links
- category, priority, and path review
- fake/trust warnings

Use plain ED2K links for import/controller workflows. Use summary-copy actions
for support notes or manual audits.

## Automation Discipline

Controllers should not flatten eMule BB into a generic download-client model.
Native distinctions matter:

- search network choice
- category
- paused vs started add
- delete/cancel semantics
- completed vs incomplete files
- source/fake/trust feedback
- local path and profile ownership

When controller behavior surprises you, compare the request with the native REST
contract and the UI operation it is supposed to represent.

## Troubleshooting

No results:

1. Confirm server/Kad state.
2. Try a simpler query.
3. Try another search method.
4. Refresh trusted server/Kad bootstrap sources.
5. Compare controller search tokens with REST docs.

Slow uploads:

1. Set a finite upload limit.
2. Check upload slot target.
3. Review ratio/slot columns.
4. Check diagnostic IO and upload timer data.
5. Check active upload socket buffer samples.

Poor names:

1. Compare source names.
2. Check fake/trust signals.
3. Review comments and file details.
4. Avoid batch cleanup until selected rows are trustworthy.
