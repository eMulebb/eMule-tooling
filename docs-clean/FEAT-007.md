---
id: FEAT-007
title: Windows Property Store integration for non-media file metadata
status: Open
priority: Minor
category: feature
labels: [metadata, windows-api, exploratory]
milestone: ~
created: 2026-04-08
source: REFACTOR-TASKS.md (REFAC_010)
---

## Summary

The current metadata pipeline uses `MediaInfo.dll` as the primary metadata
source for all file types. For non-audio/video files (images, documents,
PDFs, archives), the Windows Property Store (`IPropertyStore`) can provide
rich metadata (author, title, page count, dimensions, etc.) without an
additional library dependency.

**Status: Exploratory — not committed to implementation.**

## Proposed Architecture

1. **First path**: try Windows Property Store (`IPropertyStore`) via
   `SHGetPropertyStoreFromParsingName()`.
2. **Fallback**: `MediaInfo.dll` where it adds coverage beyond the Windows
   property system.
3. **Result merge**: combine results from both sources, preferring the
   most specific value.

## Why Now

- The `id3lib` removal (commit `907e675`) already consolidated MP3 metadata
  onto `MediaInfo`.
- `MediaInfo` is being refactored into per-format files anyway.
- Windows Property Store is available on all supported OS versions (Windows 10+).

## Scope

- File types NOT currently handled well by `MediaInfo` alone:
  - Office documents (`.docx`, `.xlsx`, `.pptx`)
  - PDF files
  - Images (EXIF via Windows Imaging Component / Shell Properties)
  - ZIP archives (`.zip`, `.7z`)

## Risk

Unknown effort — the Windows Property Store API surface is wide and
per-format coverage varies. The "exploratory" status reflects this.

## Files

- `srchybrid/FileInfoDialog.cpp` / `.h` — metadata display
- `srchybrid/MediaInfo*.cpp` / `.h` — existing MediaInfo integration
- New: `srchybrid/PropertyStoreMetadata.cpp` / `.h` (if pursued)
