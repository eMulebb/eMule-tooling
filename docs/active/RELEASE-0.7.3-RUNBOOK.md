# eMule Broadband Edition 0.7.3 Beta Release Runbook

This runbook is the operator path for proving `emule-bb-v0.7.3`. Use it with
[RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md); the checklist records the
evidence and final ship decisions.

Current status: beta 0.7.3 is cut from the selected reviewed `main` commit
after refreshed proof passes and the operator gives a separate tagging
instruction. `release/v0.72a-broadband` is a pre-release
stabilization/reference branch for this beta, not the tag source. The runbook is
the path to prove and cut a release; it is not evidence that a release already
exists.

## Preflight

Start from the workspace root and keep all build/test operations behind the
supported workspace entrypoint.

```powershell
python -m emule_workspace validate
git -C repos\eMule-tooling status --short --branch
git -C repos\eMule-build status --short --branch
git -C repos\eMule-build-tests status --short --branch
git -C workspaces\v0.72a\app\eMule-main status --short --branch
git -C workspaces\v0.72a\app\eMule-main rev-parse --short HEAD
```

Do not continue to tagging if any active repo has unrelated uncommitted changes
or if `validate` fails.

## Build And Native Test Proof

Run the release build and test baseline before live-network validation.

```powershell
python -m emule_workspace build app --config Debug --platform x64
python -m emule_workspace build app --config Release --platform x64
python -m emule_workspace build tests --config Debug --platform x64
python -m emule_workspace build tests --config Release --platform x64
python -m emule_workspace test all --config Debug --platform x64
python -m emule_workspace test all --config Release --platform x64
```

Record the command output summary and any report paths in the checklist rows
for the gates being closed.

## Live E2E Proof

Run the short backend green lane first:

```powershell
python -m emule_workspace test live-e2e --profile beta-green --fail-fast
```

Run the focused controller API surface lane before the final release lane:

```powershell
python -m emule_workspace test live-e2e --profile controller-surface --fail-fast
```

The controller-surface lane is the named proof for native `/api/v1`,
qBittorrent-compatible `/api/v2`, Torznab/Arr, and aMuTorrent. See
[CONTROLLER-SURFACE-MATRIX](CONTROLLER-SURFACE-MATRIX.md).

Run the full maintained Release x64 live lane:

```powershell
python -m emule_workspace test live-e2e --config Release --platform x64
```

The default aggregate run must include:

- `preference-ui`
- `shared-files-ui`
- `config-stability-ui`
- `shared-hash-ui`
- `startup-profile`
- `shared-directories-rest`
- `rest-api`
- `amutorrent-browser-smoke`
- `prowlarr-emulebb`
- `radarr-sonarr-emulebb`
- `auto-browse-live`

The primary release artifact is:

```text
repos\eMule-build-tests\reports\live-e2e-suite-latest\result.json
```

Beta 0.7.3 cannot ship with any `failed` suite in this artifact. A live-network
suite may be accepted as `inconclusive` only when its child report proves the
product and harness behaved correctly and the checklist records the external
condition that prevented proof.

## Focused Diagnostic Runs

Use focused runs only to diagnose or close a specific gate. They do not replace
the final full live E2E run.

```powershell
python -m emule_workspace test live-e2e --config Release --platform x64 --suite rest-api
python -m emule_workspace test live-e2e --config Release --platform x64 --suite rest-api --rest-stress-budget soak
python -m emule_workspace test live-e2e --config Release --platform x64 --suite amutorrent-browser-smoke
python -m emule_workspace test live-e2e --config Release --platform x64 --suite prowlarr-emulebb --suite radarr-sonarr-emulebb
```

Use `-SkipLiveSeedRefresh`, `-RestDownloadTriggerCount 0`, or `-LiveFailFast`
only for diagnosis. Do not use those reduced modes as final release proof.

## Ship Decision

After the final full run:

- update [RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md) with command,
  commit, artifact, status, and ship decision evidence
- confirm
  [RELEASE-0.7.3-PENDING-EXECUTION-PLAN](plans/RELEASE-0.7.3-PENDING-EXECUTION-PLAN.md)
  has no unaccepted P0 blocker remaining
- confirm every gate is `Passed` or `Inconclusive Accepted`
- confirm every release candidate is shipped, deferred, or promoted
- confirm release notes use `eMule broadband edition` as the full product name
  and `eMule BB` as the compact app/mod name
- create the annotated tag on the selected reviewed `main` commit only after
  the checklist is complete

The beta tag is:

```text
emule-bb-v0.7.3
```

The release ZIP assets must be named:

```text
eMule-broadband-0.7.3-x64.zip
eMule-broadband-0.7.3-arm64.zip
```

The supported packaging command is:

```powershell
python -m emule_workspace package-release --config Release --platform x64
python -m emule_workspace package-release --config Release --platform ARM64
```

Package manifests are written next to the ZIP assets under:

```text
workspaces\v0.72a\state\release\emule-bb-v0.7.3
```
