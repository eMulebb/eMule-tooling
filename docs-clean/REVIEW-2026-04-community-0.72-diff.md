# community-0.72 Diff Review

## Scope

Review scope is restricted to the `srchybrid` delta between:

- `workspaces\v0.72a\app\eMule-main\srchybrid`
- `analysis\community-0.72\srchybrid`

The goal of this pass is stabilization and minimal drift from community behavior, not new
architecture work. Async socket migration remains a future phase.

Review date: `2026-04-12`

## Findings

### 1. Confirmed bug: long-path recycle-bin delete is still unsafe

`srchybrid/OtherFunctions.cpp` now uses `LongPathSeams` for direct file deletion, but the
recycle-bin path in `ShellDeleteFile()` still builds a `MAX_PATH + 1` buffer and calls
`SHFileOperation`.

This is the strongest confirmed correctness gap in the reviewed diff because it sits in a
live delete path used by part-file and shared-file UI flows.

Tracked as:

- `BUG-022`
- `FEAT-010` follow-up hardening

### 2. Long-path phase 2 remains intentionally incomplete

The diff confirms the core filesystem work is real and useful, but shell/path-helper tails
are still deferred in code and should remain a stabilization priority:

- `SHGetFolderPath`
- `SHBrowseForFolder` / `SHGetPathFromIDList`
- `PathCanonicalize`
- several `GetModuleFileName` path-building sites

These are already marked as `TODO:MINOR(FEAT-010)` in code and should not be forgotten now
that the core path layer has landed.

### 3. Part-file core diffs are mostly hardening, not fresh blockers

The part-file delta versus community is large, but the reviewed changes are mostly aligned
with stabilization:

- atomic `.part.met` replacement and guarded backup writes
- shutdown flush ordering hardening
- hash-layout generation guard
- queued UI/progress updates instead of raw worker-thread pointer posting

No stronger new part-file blocker was confirmed in this diff pass than the already-tracked
hashing/concurrency work plus the long-path delete/UI tails.

### 4. WebServer drift exists and should now be managed deliberately

`WebServer.cpp` has useful long-path file-open hardening, but it also drifted from
community behavior in a few places, especially around preferences/graph handling. None of
the reviewed drift rose to the same severity as `BUG-022`, but it is enough to justify a
clear WebServer-first API plan rather than continuing the pipe/sidecar-first docs.

### 5. REST should extend WebServer.cpp, not start with a sidecar

For the next feature phase, the least-drift path is to extend the existing WebServer
surface with authenticated JSON endpoints over the current HTTP/HTTPS listener. That keeps:

- auth/session behavior in one place
- TLS handling in one place
- deployment simple
- behavior close to the existing web stack

An optional external gateway/client layer can remain a later follow-up, but it should not
define the primary architecture anymore.

## Backlog Direction

Recommended stabilization order after this review:

1. `BUG-022`
2. `FEAT-010`
3. `FEAT-013`
4. `CI-008`

Explicitly defer:

- `REF-029` async socket / WSAPoll
- `REF-030` async hostname resolver follow-up

## External References

- `SHFILEOPSTRUCT` / `SHFileOperation` guidance:
  <https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shfileopstructa>
- `CreateDirectory` long-path documentation:
  <https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createdirectoryw>
- `GetModuleFileName` truncation behavior:
  <https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew>
- `PathCanonicalize` buffer-bound API:
  <https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-pathcanonicalizew>
