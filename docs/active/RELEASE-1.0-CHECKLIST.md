# eMule Broadband Edition 1.0 Release Checklist

This is the operator checklist for `emule-bb-v1.0.0`. It does not own gate
status; use [RELEASE-1.0](RELEASE-1.0.md) for release decisions and item docs
for detailed completion evidence.

Current status: Release 1 gate proof is freshly revalidated on 2026-05-09,
release packages are created, and the annotated app tag is pushed.

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

- [x] `pwsh -File repos\eMule-build\workspace.ps1 validate`
- [x] `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082028`.
- [x] `pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082040`.
- [x] `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Debug -Platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082045`.
- [x] `pwsh -File repos\eMule-build\workspace.ps1 build-tests -Config Release -Platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082051`.
- [x] `pwsh -File repos\eMule-build\workspace.ps1 test -Config Debug -Platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082054-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`.
- [x] `pwsh -File repos\eMule-build\workspace.ps1 test -Config Release -Platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082112-eMulebb-workspace-v0.72a-eMule-main-x64-Release`.
- [x] full Release x64 `live-e2e` passed; artifact
      `repos\eMule-build-tests\reports\live-e2e-suite\20260509-093500-eMule-main-release\result.json`.
      `auto-browse-live` was accepted as inconclusive because the live networks
      connected but no safe downloadable browse-capable sourced transfer was
      available.
- [x] `pwsh -File repos\eMule-tooling\ci\check-clean-worktree.ps1 -EmuleWorkspaceRoot .`
      passed on 2026-05-09 after the fresh proof evidence commit.

## Release Identity

- [x] release notes use `eMule broadband edition` as the public product name
- [x] release notes use `eMule BB` as the compact app/mod name
- [x] annotated tag is `emule-bb-v1.0.0`
- [x] x64 asset is `eMule-broadband-1.0.0-x64.zip`
- [x] ARM64 asset is `eMule-broadband-1.0.0-arm64.zip`

## Final Operator Steps

- [x] record final command summaries and artifact paths in the relevant gate
      item docs
- [x] confirm no active workspace repo has unrelated uncommitted changes
- [x] create release packages
      - `workspaces\v0.72a\state\release\emule-bb-v1.0.0\eMule-broadband-1.0.0-x64.zip`
        SHA-256 `2d3ebe784e74baf1cfb78b38d4d965aff37875eaaa31de508ee452b1d8cb77e6`
      - `workspaces\v0.72a\state\release\emule-bb-v1.0.0\eMule-broadband-1.0.0-arm64.zip`
        SHA-256 `613727fd23c4cfa35706ac3c812a332c75af165e996e9bd8f16e27a0902af86e`
- [x] create the annotated tag only after package verification
      `emule-bb-v1.0.0` pushed to `eMulebb/eMule` at app commit `953a39f`.
