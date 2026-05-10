# eMule Broadband Edition 0.7.3 Beta Release Checklist

This is the active operator checklist for beta target
`emule-bb-v0.7.3`. Use [RELEASE-0.7.3](RELEASE-0.7.3.md) for gate status and item docs for detailed completion evidence.

Current status: the previous `1.0.0` and `1.0.1` evidence passes are superseded.
The beta 0.7.3 checklist must be refreshed on current `main` before tagging or publishing assets.

## Gate Revalidation

- [ ] [RELEASE-0.7.3](RELEASE-0.7.3.md) shows every release gate as passed or
      explicitly accepted as inconclusive
- [ ] every gate item has current implementation evidence and validation
      artifacts in its item doc
- [ ] every candidate is shipped, promoted, or explicitly deferred in
      [RELEASE-0.7.3](RELEASE-0.7.3.md)
- [ ] any accepted inconclusive live-network result records the external
      condition that blocked proof

## Required Commands

- [ ] `python -m emule_workspace validate`
- [ ] `python -m emule_workspace build app --config Debug --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082028`.
- [ ] `python -m emule_workspace build app --config Release --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082040`.
- [ ] `python -m emule_workspace build tests --config Debug --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082045`.
- [ ] `python -m emule_workspace build tests --config Release --platform x64`
      passed; build logs `workspaces\v0.72a\state\build-logs\20260509-082051`.
- [ ] `python -m emule_workspace test all --config Debug --platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082054-eMulebb-workspace-v0.72a-eMule-main-x64-Debug`.
- [ ] `python -m emule_workspace test all --config Release --platform x64`
      passed; native coverage
      `repos\eMule-build-tests\reports\native-coverage\20260509-082112-eMulebb-workspace-v0.72a-eMule-main-x64-Release`.
- [ ] full Release x64 `live-e2e` passed; artifact
      `repos\eMule-build-tests\reports\live-e2e-suite\20260509-093500-eMule-main-release\result.json`.
      `auto-browse-live` was accepted as inconclusive because the live networks
      connected but no safe downloadable browse-capable sourced transfer was
      available.
- [ ] `python repos\eMule-tooling\ci\check-clean-worktree.py`
      passed on 2026-05-09 after the fresh proof evidence commit.

## Release Identity

- [ ] release notes use `eMule broadband edition` as the public product name
- [ ] release notes use `eMule BB` as the compact app/mod name
- [ ] annotated beta tag is `emule-bb-v0.7.3`
- [ ] x64 beta asset is `eMule-broadband-0.7.3-x64.zip`
- [ ] ARM64 beta asset is `eMule-broadband-0.7.3-arm64.zip`

## Final Operator Steps

- [ ] record final command summaries and artifact paths in the relevant gate
      item docs
- [ ] confirm no active workspace repo has unrelated uncommitted changes
- [ ] create beta release packages
      - `workspaces\v0.72a\state\release\emule-bb-v0.7.3\eMule-broadband-0.7.3-x64.zip`
        SHA-256 `2d3ebe784e74baf1cfb78b38d4d965aff37875eaaa31de508ee452b1d8cb77e6`
      - `workspaces\v0.72a\state\release\emule-bb-v0.7.3\eMule-broadband-0.7.3-arm64.zip`
        SHA-256 `613727fd23c4cfa35706ac3c812a332c75af165e996e9bd8f16e27a0902af86e`
- [ ] create the annotated beta tag only after package verification
      `emule-bb-v0.7.3` on the selected release commit.
