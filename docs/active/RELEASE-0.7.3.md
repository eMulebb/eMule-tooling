# eMule Broadband Edition 0.7.3 Beta Release Dashboard

This is the current release dashboard for beta target `emule-bb-v0.7.3`.
Use it for status, release-source truth, and the open beta task list.

## Current Status

- Status: Blocked.
- Release source: selected reviewed `main` commit in
  `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main`.
- Tag target: `emule-bb-v0.7.3` on the selected reviewed `main` commit after
  fresh proof passes and the operator gives a separate tagging instruction.
- Stock/community comparison baseline: `release/v0.72a-community`.
- Stabilization reference: `release/v0.72a-broadband`; it is not the beta
  `0.7.3` tag source.
- Package publication: held until all beta-blocking item IDs below are closed
  or explicitly accepted, final proof passes, and fresh packages are generated.

## Release Identity

- Public product name: `eMule broadband edition`
- Compact app/mod/API name: `eMule BB`
- GitHub organization and URL slug: `emulebb`
- Tag: `emule-bb-v0.7.3`
- Assets:
  - `eMule-broadband-0.7.3-x64.zip`
  - `eMule-broadband-0.7.3-arm64.zip`

Superseded `1.0.0`, `1.0.1`, and `1.1.1` labels are internal evidence only.
Do not publish GitHub releases or package assets for those labels.

## Active Control Docs

- [Execution plan](plans/RELEASE-0.7.3-EXECUTION-PLAN.md)
- [Operator checklist](RELEASE-0.7.3-CHECKLIST.md)
- [Operator runbook](RELEASE-0.7.3-RUNBOOK.md)
- [Controller surface matrix](CONTROLLER-SURFACE-MATRIX.md)

Historical gate evidence and superseded cluster plans live under
`docs\history\release-0.7.3`. Audit provenance lives under `docs\audits`.

## Open Beta Tasks

| ID | Priority | Area | Required outcome |
|----|----------|------|------------------|
| [BUG-102](items/BUG-102.md) | Major | aMuTorrent live E2E | Browser smoke uses the generated harness port or reliably discovers the actual isolated port. |
| [BUG-111](items/BUG-111.md) | Critical | Release/update trust | Release, update, and help URLs use the policy-owned `emulebb` namespace. |
| [BUG-112](items/BUG-112.md) | Critical | Web auth | Legacy WebServer/qBit-compatible session tokens use CSPRNG-backed generation and fail closed. |
| [CI-034](items/CI-034.md) | Major | Packaging | `package-release` rejects dirty provenance and records the selected `main` source accurately. |
| [CI-035](items/CI-035.md) | Major | Final proof | Current-head beta proof passes and fresh x64/ARM64 package hashes are recorded. |
| [REF-034](items/REF-034.md) | Minor | Dependencies | Crypto++ 8.4 vs 8.9 beta decision is explicit and docs/topology agree. |

`FEAT-056` remains post-beta automation and evidence UX work. It is not a beta
tag blocker unless a later item promotes a specific slice.

## Ship Rule

Beta `0.7.3` can be tagged only when:

- every row in **Open Beta Tasks** is Done or explicitly accepted in its item
  doc;
- [RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md) records fresh command,
  artifact, commit, and package evidence;
- no active workspace repo has unrelated uncommitted changes; and
- the operator gives a separate tagging instruction.
