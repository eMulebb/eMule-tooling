# Beta 0.7.3 Download Completion Hook Execution Plan

> Historical release plan only. Current beta `0.7.3` execution is controlled by
> [RELEASE-0.7.3-EXECUTION-PLAN](../../active/plans/RELEASE-0.7.3-EXECUTION-PLAN.md).

This is the active execution plan for the Release 1 download completion hook.
It does not own gate status; use [RELEASE-0.7.3](RELEASE-0.7.3-GATE-HISTORY.md) for release
decisions and [FEAT-050](../../active/items/FEAT-050.md) for completion evidence.

Current status: the hook is passed for Release 1. Future changes to completion
finalization, preferences, or token expansion must revalidate this plan before
the Release 1 evidence is reused.

## Decisions

- [FEAT-050](../../active/items/FEAT-050.md) is the only optional workflow feature promoted into
  the first release gate outside the REST/controller line.
- The feature stays disabled by default.
- The configured command is executable-only. Scripts are allowed only when the
  user explicitly chooses an executable such as `powershell.exe` or `cmd.exe`.
- eMule does not invoke a shell, expand environment variables, or wait for the
  launched process to exit.
- Launch failures are logged, not shown as modal release-blocking UI.

## Product Contract

- Global setting only, configured from Files preferences.
- Empty command fields are valid while the feature is disabled.
- Missing executable paths are rejected when enabling the feature.
- The hook runs only after a download is fully completed and retained as the
  live known/shared file.
- Failed completions, duplicate-discard paths, and app shutdown skip the hook.
- Process and thread handles are closed immediately after launch.

## Token Contract

Release 1 supports:

- `%F`: completed full file path
- `%D`: completed directory
- `%N`: completed file name
- `%H`: lowercase file hash
- `%S`: file size in bytes
- `%C`: category name

Path tokens are automatically quoted. User-provided shell metacharacters remain
literal arguments because no shell is used.

## Revalidation Path

Before reusing the Release 1 evidence after related code changes, run:

```powershell
python -m emule_workspace validate
python -m emule_workspace build tests --config Debug --platform x64
python -m emule_workspace test all --config Debug --platform x64
```

The native tests must continue to cover token expansion, disabled preference
behavior, missing executable validation, duplicate/failed/shutdown skips, and
direct `CreateProcess` request building.
