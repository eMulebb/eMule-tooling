# eMule Broadband Edition 0.7.3 Beta Release Runbook

This runbook is procedure only. Use
[RELEASE-0.7.3](RELEASE-0.7.3.md) for current release status and
[RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md) for final evidence.

## Preflight

Start from `EMULE_WORKSPACE_ROOT` and keep build/test/package work behind the
supported workspace entrypoint.

```powershell
python -m emule_workspace validate
git -C repos\eMule-tooling status --short --branch
git -C repos\eMule-build status --short --branch
git -C repos\eMule-build-tests status --short --branch
git -C workspaces\v0.72a\app\eMule-main status --short --branch
git -C workspaces\v0.72a\app\eMule-main rev-parse --short HEAD
```

Do not continue to tagging if validation fails or if any active repo has
unrelated uncommitted changes.

## Build And Native Test Proof

```powershell
python -m emule_workspace build app --config Debug --platform x64
python -m emule_workspace build app --config Release --platform x64
python -m emule_workspace build app --config Release --platform ARM64
python -m emule_workspace build tests --config Debug --platform x64
python -m emule_workspace build tests --config Release --platform x64
python -m emule_workspace test all --config Debug --platform x64
python -m emule_workspace test all --config Release --platform x64
```

Record summaries and artifact paths in [CI-035](items/CI-035.md).

## Live E2E Proof

Run the focused controller surface first:

```powershell
python -m emule_workspace test live-e2e --profile controller-surface --fail-fast
```

Then run the full maintained Release x64 live lane:

```powershell
python -m emule_workspace test live-e2e --config Release --platform x64
```

The full run must include `preference-ui`, `shared-files-ui`,
`config-stability-ui`, `shared-hash-ui`, `startup-profile`,
`shared-directories-rest`, `rest-api`, `amutorrent-browser-smoke`,
`prowlarr-emulebb`, `radarr-sonarr-emulebb`, and `auto-browse-live`.

No release-blocking suite may fail. A live-network suite may be accepted as
inconclusive only when the child report proves the app and harness behaved
correctly and the checklist records the external condition.

## Packaging

```powershell
python -m emule_workspace package-release --config Release --platform x64
python -m emule_workspace package-release --config Release --platform ARM64
```

Package manifests are written next to the ZIP assets under:

```text
workspaces\v0.72a\state\release\emule-bb-v0.7.3
```

The release ZIP assets must be named:

```text
eMule-broadband-0.7.3-x64.zip
eMule-broadband-0.7.3-arm64.zip
```

## Ship Decision

After the final proof:

- update [CI-035](items/CI-035.md) and
  [RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md);
- confirm [RELEASE-0.7.3](RELEASE-0.7.3.md) has no open beta-blocking task
  without item-level acceptance;
- confirm release notes use `eMule broadband edition` and `eMule BB`; and
- create `emule-bb-v0.7.3` only after package verification and a separate
  operator instruction.
