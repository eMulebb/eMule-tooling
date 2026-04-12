---
id: FEAT-010
title: Long path support phase 2 — shell/UI icon, browse, recycle-bin delete, and path-helper audit
status: In Progress
priority: Minor
category: feature
labels: [longpath, max-path, windows, filesystem, shell, ui]
milestone: ~
created: 2026-04-08
source: GUIDE-LONGPATHS.md + feature/windows-long-paths audit
---

## Summary

Core long-path support is already landed on `main` for filesystem operations. Phase 2
shell/UI hardening and helper cleanup are now implemented on the active stabilization
branches and are pending merge back to `main`.

The implementation now covers:

- recycle-bin delete through `IFileOperation` instead of `SHFileOperation`
- dynamic path-helper cleanup for shell-facing module/profile/path assembly
- shared `IFileDialog` wrappers for file/folder pickers
- centralized shell icon/display fallback behavior for overlong paths
- silent `.lnk` ignore-by-extension in the relevant share/incoming scans
- dynamic skin-resource path resolution without `MAX_PATH` scratch buffers
- consolidation of generic path semantics into `PathHelpers` and shell/UI policy into `ShellUiHelpers`
- deterministic regression coverage in `eMule-build-tests` for delete, path-helper, and shell/UI seam behavior

## Already Landed On Main

The following are no longer backlog items:

- `x64` and `ARM64` manifests carry `<ws2:longPathAware>true</ws2:longPathAware>`
- startup detects and logs whether `LongPathsEnabled` is enabled
- `LongPathSeams` centralizes Win32 file APIs, CRT-bypass file descriptors, `FILE*` streams, and MFC safe-file opens
- part files, config files, archive/import flows, ZIP/GZIP, web cert/key output, and similar high-value paths already use the shared long-path model
- real filesystem tests now cover long Unicode paths, Cyrillic/emoji path segments, generated payloads, copy/move/delete flows, and parity-style reference coverage

## Implemented Scope

The active stabilization branches now cover the full FEAT-010 shell/UI tail:

- `PathHelpers.h`: permanent generic path-helper layer for separator normalization, extended-length prefix handling, directory canonicalization, path joins, dynamic module/shell-folder retrieval, and related path-shape rules
- `ShellUiHelpers.h`: permanent shell/UI helper layer for picker normalization, shell icon/display fallback policy, shortcut ignore rules, and skin-resource resolution
- `Ini2Helpers.h`: INI-specific helper layer trimmed down to config/path decisions that reuse `PathHelpers` instead of duplicating generic path logic
- `OtherFunctions.cpp/.h`: shared `IFileDialog` wrappers for folder pick, file open, and file save; compatibility entrypoints retained for `SelectDir(...)` and `DialogBrowseFile(...)`
- `PartFileConvert.cpp`, `TreeOptionsCtrl.cpp`, `KnownFile.cpp`, `PPgFiles.cpp`, `MuleToolBarCtrl.cpp`, `StatisticsTree.cpp`, `CatDialog.cpp`, `PPgDirectories.cpp`: migrated remaining browse/picker call sites to the shared wrappers
- `DirectoryTreeCtrl.cpp`, `SharedDirsTreeCtrl.cpp`, `Emule.cpp`: centralized icon/display fallback behavior for shell-facing UI
- `PPgDirectories.cpp`, `SharedFileList.cpp`, `SharedFilesCtrl.cpp`: `.lnk` files are now ignored by extension in the relevant share/incoming scans instead of consulting shell metadata
- `FileInfoDialog.cpp`, `MiniMule.cpp`, `OtherFunctions.cpp`: path-helper/module-path tails removed in the earlier FEAT-010 path-helper slice
- `Emule.cpp`, `MuleListCtrl.cpp`: skin resource and background image resolution now use dynamic helper paths rather than `MAX_PATH` buffers
- `TreeOptionsCtrl.cpp/.h`, `OtherFunctions.cpp/.h`: dead legacy picker-era code was removed, including `CTreeOptionsFileDialog`, `SHBrowseSetSelProc`, and the unused raw-buffer `SelectDir(HWND, LPTSTR, ...)` overload
- broader `srchybrid` callers now use shared helper rules instead of duplicated `slosh` / `unslosh` / `MakeFoldername` semantics

There are no remaining `TODO:MINOR(FEAT-010)` or `TODO:MINOR(longpath)` markers in the audited shell/UI long-path surface.

## Fallback Policy

The Phase 2 implementation uses explicit shell/UI fallback behavior instead of relying on incidental shell success:

- icon lookup uses stable extension/attribute-based queries where possible rather than probing the full overlong path
- shell display names are optional enrichment; when the shell cannot provide one safely, existing caller text is preserved
- picker flows return full `CString` paths from shared modern wrappers instead of caller-owned `MAX_PATH` arrays
- `.lnk` files are ignored by extension in the relevant share/incoming warning flows instead of following shell metadata
- directory-valued paths now share one normalization contract through `PathHelpers` instead of per-call-site trailing-`\` logic

## Test Expansion

The stabilization branches now include:

- deep Unicode delete coverage for recycle-bin-enabled and direct-delete routing
- path-helper coverage for module paths, canonicalization, MediaInfo path joins, and MiniMule resource URLs
- shell/UI seam coverage for shortcut ignore rules, shell display fallback gating, icon-query routing, picker path splitting/finalization, and skin-resource resolution

Remaining verification before merge is manual smoke coverage for representative browse/icon flows on a live UI.

## Final Helper Architecture

The active stabilization branches now use a permanent helper split instead of the earlier
transitional seam naming:

- `PathHelpers`: generic path semantics only
- `ShellUiHelpers`: shell/UI policy only
- `OtherFunctionsSeams`: delete-route seam/injection only where tests need it

This cleanup also removes duplicate extended-length prefix handling, duplicate
trailing-separator helpers, and duplicate directory-shape normalization from the audited
and overlapping `srchybrid` long-path surface.

## Acceptance Criteria

- [x] Shell icon/display lookup is centralized and no longer scattered across the audited tree/list controls
- [x] Overlong paths still get sensible icons or graceful fallback behavior in directory/file UI
- [x] Browse-dialog flows are audited and routed through shared modern wrappers in the audited files
- [x] Delete-to-recycle-bin behavior for deep paths is explicitly hardened
- [x] Fixed-buffer path composition used in real path construction is reduced or eliminated in the audited files
- [ ] Manual smoke checks cover icon lookup and browse flows for deep Unicode paths where the shell APIs permit it

## Reference

- Core implementation spec: `docs/GUIDE-LONGPATHS.md`
- Microsoft shell/file API notes:
  - <https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shfileopstructa>
  - <https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createdirectoryw>
  - <https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew>
  - <https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-pathcanonicalizew>
