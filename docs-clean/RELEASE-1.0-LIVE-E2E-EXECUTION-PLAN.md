# Release 1.0 Live E2E Execution Plan

This is the active execution plan for the Release 1 live E2E umbrella. It does
not own gate status; use [RELEASE-1.0](RELEASE-1.0.md) for release decisions
and [CI-011](CI-011.md) for completion evidence.

Current status: the broadband branch remains pre-release stabilization. The
full Release x64 live lane must pass again before any tag or package is cut.

## Decisions

- [CI-011](CI-011.md) owns the operator-facing aggregate command and result
  artifact shape.
- The final release proof is the full Release x64 `live-e2e` run, not a set of
  focused diagnostic runs.
- Focused `live-e2e` suites are valid for diagnosis and gate repair, but they
  do not replace the final aggregate proof.
- Public-network failures may be accepted as inconclusive only when the child
  report proves that the app and harness behaved correctly.
- The live lane must use isolated temp profiles and must not depend on the
  operator's normal eMule profile state.

## Gate Map

| Area | Release item | Execution responsibility |
|------|--------------|--------------------------|
| Aggregate release lane | [CI-011](CI-011.md) | one supported command, stable suite selection, and aggregate result artifact |
| REST robustness | [BUG-075](BUG-075.md), [BUG-076](BUG-076.md), [BUG-077](BUG-077.md), [CI-014](CI-014.md), [CI-015](CI-015.md) | included through the `rest-api` suite |
| Controller integrations | [AMUT-001](AMUT-001.md), [ARR-001](ARR-001.md) | included through aMuTorrent and Arr live suites |
| Release identity | [RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md) | final operator evidence and artifact naming checks |

## Required Aggregate Suites

The final aggregate run must include:

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

## Result Rules

- No release-blocking suite may have status `failed`.
- `passed` is required for deterministic local suites.
- `inconclusive` is acceptable only for live-network proof where diagnostics
  distinguish unavailable external conditions from product or harness failure.
- The aggregate artifact must record status, command line, timings, suite
  result paths, and failure phase for failed or inconclusive child suites.
- Reports must redact API keys and exact live-wire transfer identifiers.

## Revalidation Path

Before Release 1 tagging, run:

```powershell
pwsh -File repos\eMule-build\workspace.ps1 validate
pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64
```

Record the aggregate result path and any accepted inconclusive external
condition in [CI-011](CI-011.md) and
[RELEASE-1.0-CHECKLIST](RELEASE-1.0-CHECKLIST.md).
