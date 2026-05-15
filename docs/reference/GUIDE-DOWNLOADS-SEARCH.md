# Downloads And Search Guide

This guide covers search modes, result trust/fake feedback, download controls,
categories, and power-user file workflows.

## Search Modes

eMule BB preserves native eMule search distinctions:

- Server search queries the current server.
- Global search uses the server network more broadly.
- Kad search uses decentralized Kad search.
- Automatic/controller searches should respect the selected native network policy.

Use server search when a trusted server is enough, global search when server
coverage matters, and Kad when decentralized discovery is the better fit.

## Search Result Quality

Search results can include fake or low-quality names. eMule BB surfaces
fake-file and trust signals so users can understand why a result looks risky.

Useful cues:

- filename agreement across sources
- suspicious extension/name combinations
- fake-file detector matches
- source count and result consistency
- comments and known metadata when available

Do not rely on a single signal. Use details, comments, and source agreement
before committing to questionable results.

## Download Actions

Common download actions:

- start/resume
- pause
- stop
- cancel with confirmation
- cancel without confirmation by using the shifted shortcut/menu path
- open completed file
- open containing folder
- show details
- copy ED2K links and summaries
- change priority

Keyboard shortcuts are documented in [Keyboard Shortcuts](KEYBOARD-SHORTCUTS.md).

## Categories

Categories organize downloads and can carry different workflow expectations.
Use the category manager for normal editing. It prevents deleting categories
that are still assigned to downloads.

Good category practice:

- keep names short and meaningful
- avoid renaming categories while automation expects a specific name
- move downloads intentionally before removing a category
- keep a default catch-all category for unsorted items

## Filename Cleanup

Filename cleanup tries to improve selected download names without breaking the
download identity. It should never blindly reduce a name to a generic word.
When using majority/fake cleanup, verify the selected result details before
accepting a rename.

If a name becomes suspiciously generic, check:

- source names
- known fake detector feedback
- file extension
- category destination
- comments and details

## File Details

Use details for:

- source/name comparison
- comments
- hashes and ED2K links
- category or priority review
- diagnosing fake/trust warnings

Details are especially useful before downloading rare files or files with many
similar names.

## Copy Workflows

Context menus expose copy submenus for power users. Common copy fields include:

- ED2K links
- file name
- file path
- folder path
- size
- status
- progress
- type
- summary line

Use plain ED2K links for controller/import workflows. Use summaries for support
or manual audit notes.

## Automation Discipline

Controllers should not flatten eMule into a generic download-client model.
Native distinctions matter:

- search network choice
- category
- paused vs started add
- delete semantics
- completed-file handling
- source and fake/trust feedback

When controller behavior surprises you, compare its assumptions with the REST
contract and the native UI operation.
