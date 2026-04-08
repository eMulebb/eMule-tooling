---
id: FEAT-010
title: Long path support — lift MAX_PATH limit via manifest + CRT-bypass helpers
status: Open
priority: Minor
category: feature
labels: [longpath, max-path, windows, filesystem, compat]
milestone: ~
created: 2026-04-08
source: GUIDE-LONGPATHS.md
---

## Summary

eMule silently fails or corrupts state when dealing with files whose full paths exceed 260 characters (Windows `MAX_PATH`). Neither the application manifest nor CRT-bypass wrappers are in place. The full implementation plan is already fully specified in `GUIDE-LONGPATHS.md`.

## Background

Two independent mechanisms must both be active to lift `MAX_PATH`:

1. **System registry key:** `HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled = 1` (Windows 10 1607+, set by user or Group Policy)
2. **Application manifest:** `<ws2:longPathAware>true</ws2:longPathAware>` in the embedded `.exe` manifest

When both are active, Win32 APIs (`CreateFile`, `MoveFile`, `FindFirstFile`, etc.) accept paths up to ~32,767 characters.

**Important:** The MSVC CRT (`fopen`, `_wfopen`, `_open`, `_trename`, `_tremove`) does **not** benefit from the manifest — it has its own internal MAX_PATH check. CRT-based file operations require explicit `\\?\` prefix paths or a handle-based bypass via `_open_osfhandle` + `_fdopen`.

## Three-Layer Implementation

### Layer 1 — Registry detection (startup)

Add to `OtherFunctions.cpp` (append after line 3962):

```cpp
static bool g_bWin32LongPathsEnabled = false;

bool IsWin32LongPathsEnabled() { return g_bWin32LongPathsEnabled; }

void DetectWin32LongPathsSupportAtStartup()
{
    HKEY hKey = NULL;
    DWORD dw = 0, type = 0, cb = sizeof(dw);
    if (RegOpenKeyEx(HKEY_LOCAL_MACHINE,
            _T("SYSTEM\\CurrentControlSet\\Control\\FileSystem"),
            0, KEY_READ, &hKey) == ERROR_SUCCESS) {
        if (RegQueryValueEx(hKey, _T("LongPathsEnabled"), NULL, &type,
                reinterpret_cast<LPBYTE>(&dw), &cb) == ERROR_SUCCESS && type == REG_DWORD)
            g_bWin32LongPathsEnabled = (dw != 0);
        RegCloseKey(hKey);
    }
}
```

Add declarations to `OtherFunctions.h`. Call `DetectWin32LongPathsSupportAtStartup()` from `CemuleApp::InitInstance()`.

### Layer 2 — Path preparation

```cpp
CString PreparePathForWin32LongPath(const CString& path)
{
    if (path.IsEmpty()) return path;
    if (path.Left(4).CompareNoCase(_T("\\\\?\\")) == 0) return path;
    const bool needPrefix = g_bWin32LongPathsEnabled || path.GetLength() >= MAX_PATH;
    if (!needPrefix) return path;
    if (path.Left(2) == _T("\\\\"))
        return _T("\\\\?\\UNC\\") + path.Mid(2);
    return _T("\\\\?\\") + path;
}
```

### Layer 3 — CRT-bypass open helpers

```cpp
// Returns FILE* opened via CreateFile + _open_osfhandle + _fdopen
// Needed because CRT fopen/_wfopen ignores the manifest and has its own MAX_PATH check
FILE* OpenFileStreamSharedReadLongPath(const CString& path, const wchar_t* mode);
int   OpenCrtReadOnlyLongPath(const CString& path);
```

Both functions use `CreateFile` (respects manifest) and attach the OS handle to a CRT fd.

## Manifest Change

File: `res/eMule.exe.manifest` (or the embedded manifest in the `.rc` / linker manifest)

```xml
<ws2:requestedExecutionLevel level="asInvoker" uiAccess="false"/>
<ws2:longPathAware>true</ws2:longPathAware>
```

## Call-Site Changes (by file)

| File | Change |
|------|--------|
| `SharedFileList.cpp` | Wrap `FindFirstFile`/`FindNextFile` paths with `PreparePathForWin32LongPath` |
| `PartFile.cpp` | Wrap `.part`, `.met`, `_backup` open paths with Layer 3 helpers |
| `KnownFile.cpp` | Wrap `GetMetaDataFromMP3File`, `GetMetaDataFromWMAFile` open calls |
| `SafeFile.cpp` | Wrap `Open()` with Layer 3 helpers |
| `OtherFunctions.cpp` | Wrap `_tremove`, `_trename` calls with `PreparePathForWin32LongPath` |
| `Preferences.cpp` | Wrap all temp-file and ini-write paths |

## Graceful Degradation

Before any operation that will fail for long paths, guard with:

```cpp
if (!IsWin32LongPathsEnabled() && path.GetLength() >= MAX_PATH) {
    AddLogLine(false, _T("Path exceeds MAX_PATH and long paths are not enabled: %s"), path);
    return false; // or appropriate error
}
```

## Protocol / .met Impact

`.met` files store paths as Pascal-prefixed UTF-16 strings. No format change is needed — the stored path can be long; only the Win32 open call needs the `\\?\` prefix.

## Acceptance Criteria

- [ ] `DetectWin32LongPathsSupportAtStartup()` called at startup; result logged
- [ ] `PreparePathForWin32LongPath()` applied at all `FindFirstFile`/`MoveFile`/`DeleteFile` call sites
- [ ] `OpenFileStreamSharedReadLongPath()` used in `PartFile` and `SafeFile` open paths
- [ ] `longPathAware` flag added to application manifest
- [ ] Manual test: share a file at a >260-char path — it hashes and transfers correctly
- [ ] Manual test: without registry key set — long-path attempt logs warning, no crash

## Reference

Full implementation spec: `docs/GUIDE-LONGPATHS.md`
