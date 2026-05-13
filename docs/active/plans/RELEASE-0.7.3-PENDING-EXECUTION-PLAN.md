# Beta 0.7.3 Pending Execution Plan

This is the active execution plan for the remaining beta `emule-bb-v0.7.3`
release work after the 2026-05-11 readiness audits and the 2026-05-13 release
source decision.

## Current Decision

- Release source: selected reviewed `main` commit in
  `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main`.
- Tag target: the same selected reviewed `main` commit after final proof passes
  and the operator gives a separate tagging instruction.
- Stabilization reference: `release/v0.72a-broadband`; it is not the beta
  0.7.3 tag source.
- Stock/community comparison baseline: `release/v0.72a-community`.
- Latest heads observed before this plan was written:
  - app `main`: `11bbe28`
  - build orchestration: `2749b61`
  - build-tests: `5ecc9f1`
  - tooling: `a5a550d`

## P0 Release Blockers

| Area | Required outcome | Evidence to record |
|------|------------------|--------------------|
| Release and help URLs | App release/update/help URLs point at the policy-owned `emulebb` namespace, not superseded `itlezy/eMule` locations. | App commit, focused release-update tests, and a source grep showing no stale public release URL remains. |
| Web session token generation | Legacy WebServer/qBit-compatible session tokens use CSPRNG-backed generation and fail closed if secure randomness is unavailable. | App commit plus focused WebServer auth/session tests. |
| IP-filter transport policy | Security-input defaults no longer silently fetch the default IP-filter list over plain HTTP, or the release owner explicitly accepts the default and records the risk. | App/build commit or release-owner acceptance, plus targeted preference/update tests when code changes. |
| Crypto++ pin truth | Active dependency docs and topology agree on whether beta 0.7.3 ships Crypto++ 8.4 or upgrades to 8.9. | Topology/doc commit, `validate`, and dependency status doc update. |

## P1 Release Proof And Packaging

| Area | Required outcome | Evidence to record |
|------|------------------|--------------------|
| Package source provenance | `package-release` records `main` as the source variant/branch and rejects dirty source inputs that would make package provenance ambiguous. | Build commit, packaging tests if present, and package manifest sample. |
| Current-head proof | Minimum beta proof is rerun on the selected `main` commit after P0 fixes land. | Command summaries, app/build/build-tests/tooling commits, logs, and report paths in the checklist and item docs. |
| Fresh packages | x64 and ARM64 packages are regenerated from the selected release-ready heads. | Package paths, SHA-256 hashes, manifest commits, and `diff --check`/validate status. |

## P2 Release Polish

| Area | Required outcome | Evidence to record |
|------|------------------|--------------------|
| REST app identity | REST/API identity surfaces use `eMule BB` where the compact product name is expected instead of stock `eMule`. | App commit and REST contract or focused API smoke result. |
| Superseded release wording | Public-facing docs and package README avoid stale `Release 1.0` wording for beta 0.7.3. | Tooling/app doc commit and release-note review. |
| Deterministic package hashing | Decide whether deterministic ZIP metadata is required for beta 0.7.3 or deferred to post-beta proof automation. | Acceptance note in this plan or FEAT-056. |

## Execution Order

1. Complete this documentation/source-alignment update in `repos\eMule-tooling`.
2. Fix P0 app security and public identity blockers on `main`.
3. Fix dependency/package provenance policy gaps in the owning repo.
4. Rerun current-head beta proof through `python -m emule_workspace`.
5. Regenerate x64 and ARM64 beta packages from the selected release-ready heads.
6. Update [RELEASE-0.7.3-CHECKLIST](../RELEASE-0.7.3-CHECKLIST.md) and the
   affected item docs with command summaries, commits, report paths, and
   package hashes.
7. Wait for a separate operator instruction before creating or pushing
   `emule-bb-v0.7.3`.

## Validation Bar

- Docs-only updates: `git diff --check` in `repos\eMule-tooling` and
  `python -m emule_workspace validate`.
- App P0 fixes: `validate`, focused tests for the touched area, Release x64 app
  build when behavior or resources change, and relevant live E2E smoke when
  release-facing UI/API surfaces are touched.
- Build/package fixes: `validate`, package-focused tests if available, and x64
  plus ARM64 package rehearsal.

## Historical Inputs

The 2026-05-11 readiness audits remain useful provenance, but their branch
source finding is superseded by the current decision to tag beta 0.7.3 from a
reviewed `main` commit:

- [Build, test, packaging, and release](../../audits/BETA-READINESS-BUILD-RELEASE-2026-05-11.md)
- [Regression and compatibility](../../audits/BETA-READINESS-COMPATIBILITY-2026-05-11.md)
- [Feature completeness](../../audits/BETA-READINESS-FEATURES-2026-05-11.md)
- [Security](../../audits/BETA-READINESS-SECURITY-2026-05-11.md)
- [Stability](../../audits/BETA-READINESS-STABILITY-2026-05-11.md)
