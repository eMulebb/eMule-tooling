# eMule Broadband Edition 1.0 Release Checklist

This is the archived operator checklist for internal rehearsal tag
`emule-bb-v1.0.0`. It does not own gate status; use
[RELEASE-1.0](RELEASE-1.0.md) for historical decisions and item docs for
detailed completion evidence.

Current status: Release 1 gate proof is freshly revalidated on 2026-05-09,
rehearsal packages are created, and the annotated internal app tag is pushed.
Do not publish GitHub release packages for `1.0.0`; the first publishable
public release is `emule-bb-v1.1.1`.

## Gate Revalidation

- [x] [RELEASE-1.0](RELEASE-1.0.md) shows every release gate as passed or
      explicitly accepted as inconclusive
- [x] every gate item has current implementation evidence and validation
      artifacts in its item doc
- [x] every candidate is shipped, promoted, or explicitly deferred in
      [RELEASE-1.0](RELEASE-1.0.md)
- [x] any accepted inconclusive live-network result records the external
      condition that blocked proof

## Required Commands

- [x] `python -m emule_workspace validate`
- [x] `python -m emule_workspace build app --config Debug --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082028`.
- [x] `python -m emule_workspace build app --config Release --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082040`.
- [x] `python -m emule_workspace build tests --config Debug --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082045`.
- [x] `python -m emule_workspace build tests --config Release --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082051`.
- [x] `python -m emule_workspace test all --config Debug --platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082054-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`.
- [x] `python -m emule_workspace test all --config Release --platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082112-eMulebb-workspace-v0.72a-eMule-main-x64-Release`.
- [x] full Release x64 `live-e2e` passed; artifact
      `repos\eMule-build-tests\reports\live-e2e-suite\20260509-093500-eMule-main-release\result.json`.
      `auto-browse-live` was accepted as inconclusive because the live networks
      connected but no safe downloadable browse-capable sourced transfer was
      available.
- [x] `pwsh -File repos\eMule-tooling\ci\check-clean-worktree.ps1 --workspace-root .`
      passed on 2026-05-09 after the fresh proof evidence commit.

## Release Identity

- [x] release notes use `eMule broadband edition` as the public product name
- [x] release notes use `eMule BB` as the compact app/mod name
- [x] internal annotated tag is `emule-bb-v1.0.0`
- [x] internal x64 rehearsal asset is `eMule-broadband-1.0.0-x64.zip`
- [x] internal ARM64 rehearsal asset is `eMule-broadband-1.0.0-arm64.zip`

## Final Operator Steps

- [x] record final command summaries and artifact paths in the relevant gate
      item docs
- [x] confirm no active workspace repo has unrelated uncommitted changes
- [x] create internal rehearsal packages
      - `workspaces\v0.72a\state\release\emule-bb-v1.0.0\eMule-broadband-1.0.0-x64.zip`
        SHA-256 `2d3ebe784e74baf1cfb78b38d4d965aff37875eaaa31de508ee452b1d8cb77e6`
      - `workspaces\v0.72a\state\release\emule-bb-v1.0.0\eMule-broadband-1.0.0-arm64.zip`
        SHA-256 `613727fd23c4cfa35706ac3c812a332c75af165e996e9bd8f16e27a0902af86e`
- [x] create the internal annotated tag only after package verification
      `emule-bb-v1.0.0` pushed to `eMulebb/eMule` at app commit `953a39f`.
