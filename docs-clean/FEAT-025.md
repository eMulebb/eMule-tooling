---
id: FEAT-025
title: Normalize download filenames on intake and completion
status: Done
priority: Minor
category: feature
labels: [filesystem, filenames, windows, intake, completion]
milestone: ~
created: 2026-04-13
source: `main` commit `021cb5b` (`FEAT-025 normalize download filenames on intake and completion`)
---

## Summary

This feature is merged to `main`.

`eMule-main` now applies one shared filename-normalization policy when download names
enter the app and again when completed files are finalized. The goal is to prevent
invalid or lossy Windows path spellings from leaking through different intake paths
with subtly different cleanup behavior.

## Landed Mainline Shape

Mainline commit:

- `021cb5b` — `FEAT-025 normalize download filenames on intake and completion`

Primary files:

- `srchybrid/FilenameNormalizationPolicy.h`
- `srchybrid/OtherFunctions.cpp/.h`
- `srchybrid/PartFile.cpp`

## Implemented Behavior

The shared normalization policy now:

- strips invalid Windows filename characters through one helper
- trims path-hostile trailing spaces and trailing dots
- hardens reserved DOS device-looking basenames
- collapses whitespace-like placeholder separators in the basename
- falls back to the literal name `download` when cleanup would otherwise empty the name

The policy is used on the main user-facing download-name entry paths:

- search-result / tag-based part-file intake
- ED2K link initialization
- remote-name intake
- Shareaza import path
- completed-file final rename path

## Why This Matters

Before this slice, filename cleanup behavior was spread across older helpers and not all
download-intake paths were normalized the same way. Mainline now has one explicit policy
surface instead of a mixture of ad hoc cleanup and late rename corrections.

## Explicit Boundaries

This is filename normalization, not a broader path rewrite.

Out of scope:

- directory-path normalization
- locale-specific transliteration
- content-based renaming
- share-ignore policy decisions
- shell/UI long-path handling beyond the filename itself

## Relationship To Other Items

- complements **FEAT-010** long-path hardening by removing bad filename spellings earlier
- complements **FEAT-024** share-ignore policy by tightening filename intake, not share filtering
