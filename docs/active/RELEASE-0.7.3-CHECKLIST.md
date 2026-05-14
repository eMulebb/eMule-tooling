# eMule Broadband Edition 0.7.3 Beta Release Checklist

This is the final operator checklist for beta target `emule-bb-v0.7.3`.
Do not record stale proof here; every row must be refreshed on the selected
reviewed `main` commit.

## Proof Pause

Final proof is paused by operator direction on 2026-05-13. Do not run additional
live E2E, do not regenerate final packages, and do not create Git tags until a
new explicit instruction resumes release proof. Partial evidence captured before
the pause is recorded in [CI-035](items/CI-035.md); it does not complete this
checklist.

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

Current state: non-live build/test rows have partial passing evidence in
[CI-035](items/CI-035.md). Live proof, final package refresh, clean-worktree
confirmation, and final hash recording remain incomplete.

2026-05-14 closeout prep did not run live E2E, regenerate packages, or create
tags. Existing package manifests are rehearsal artifacts from older commits and
must not be used as final release hashes. Recent live reports may be cited as
supporting signal only where [CI-035](items/CI-035.md) classifies them; they do
not complete the required current-head proof rows.

The accepted [FEAT-058](../history/items/FEAT-058.md) closeout copy/audit
polish changed release-facing docs after the previous prep audit. Treat all
final proof rows as pending until rerun on the pushed heads that exist after
that polish lands.

The accepted [FEAT-059](../history/items/FEAT-059.md) tray preference UI polish
also changed the app candidate. Treat all final proof rows as pending until
rerun on the pushed heads that exist after that polish lands.

The accepted [FEAT-060](../history/items/FEAT-060.md) preference inventory and
REST preference metadata hardening also changed the app and build-tests
candidates. Treat all final proof rows as pending until rerun on the pushed
heads that exist after this hardening lands.

The accepted [FEAT-061](../history/items/FEAT-061.md) strong preference schema
validation changed the build-tests candidate. Treat all final proof rows as
pending until rerun on the pushed heads that exist after this schema hardening
lands.

When proof resumes, run the remaining queue in this order:

1. Revalidate the active release docs and item dispositions.
2. Run the required command rows above on the selected current app `main` head.
3. Regenerate x64 and ARM64 packages only after proof succeeds.
4. Record fresh package paths, manifests, SHA-256 hashes, and repo commits in
   [CI-035](items/CI-035.md).
5. Leave the annotated tag step blocked until the operator gives a separate tag
   instruction.

## Stabilization Add-On

After the proof pause is lifted, run this focused add-on only when extra
crash/leak/CPU/REST concurrency evidence is requested before the full live lane:

- [ ] `python -m emule_workspace test live-e2e --profile stabilization-stress --fail-fast`

This add-on does not replace the required controller-surface and full Release
x64 live E2E rows above.

## Release Identity

- [ ] Release notes use `eMule broadband edition` as the public product name.
- [ ] Release notes use `eMule BB` as the compact app/mod/API name.
- [ ] Package-facing README identifies reviewed `main` as the beta `0.7.3`
      release source and treats `release/v0.72a-broadband` as a stabilization
      reference only.
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
