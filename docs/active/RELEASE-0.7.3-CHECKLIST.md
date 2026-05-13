# eMule Broadband Edition 0.7.3 Beta Release Checklist

This is the final operator checklist for beta target `emule-bb-v0.7.3`.
Do not record stale proof here; every row must be refreshed on the selected
reviewed `main` commit.

## Gate Revalidation

- [ ] [RELEASE-0.7.3](RELEASE-0.7.3.md) has no open beta-blocking task without
      item-level acceptance.
- [ ] [RELEASE-0.7.3-EXECUTION-PLAN](plans/RELEASE-0.7.3-EXECUTION-PLAN.md)
      has no unaccepted blocking item remaining.
- [ ] Every beta-blocking item doc records the implementation commit,
      validation evidence, and final disposition.
- [ ] Any accepted inconclusive live-network result records the external
      condition that blocked proof.

## Required Commands

- [ ] `python -m emule_workspace validate`
- [ ] `python -m emule_workspace build app --config Debug --platform x64`
- [ ] `python -m emule_workspace build app --config Release --platform x64`
- [ ] `python -m emule_workspace build app --config Release --platform ARM64`
- [ ] `python -m emule_workspace build tests --config Debug --platform x64`
- [ ] `python -m emule_workspace build tests --config Release --platform x64`
- [ ] `python -m emule_workspace test all --config Debug --platform x64`
- [ ] `python -m emule_workspace test all --config Release --platform x64`
- [ ] `python -m emule_workspace test live-e2e --profile controller-surface --fail-fast`
- [ ] `python -m emule_workspace test live-e2e --config Release --platform x64`
- [ ] `python -m emule_workspace package-release --config Release --platform x64`
- [ ] `python -m emule_workspace package-release --config Release --platform ARM64`
- [ ] `python repos\eMule-tooling\ci\check-clean-worktree.py`

Record command summaries, commits, log paths, report paths, package paths, and
SHA-256 hashes in [CI-035](items/CI-035.md).

## Release Identity

- [ ] Release notes use `eMule broadband edition` as the public product name.
- [ ] Release notes use `eMule BB` as the compact app/mod/API name.
- [ ] Annotated beta tag is `emule-bb-v0.7.3`.
- [ ] Annotated beta tag points at the selected reviewed `main` commit.
- [ ] x64 beta asset is `eMule-broadband-0.7.3-x64.zip`.
- [ ] ARM64 beta asset is `eMule-broadband-0.7.3-arm64.zip`.

## Final Operator Steps

- [ ] Confirm no active workspace repo has unrelated uncommitted changes.
- [ ] Confirm fresh x64 and ARM64 package hashes are recorded in
      [CI-035](items/CI-035.md).
- [ ] Create the annotated beta tag only after package verification and a
      separate operator instruction.
