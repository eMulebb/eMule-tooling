# Beta 0.7.3 Closeout UX Polish Audit - 2026-05-14

## Summary

This audit records the final accepted beta closeout polish before release proof
resumes. The selected closeout track is small release-facing UX polish, the
evidence policy is fresh current-head proof only, and the durable artifact is
this audit report.

The polish does not complete `CI-035`. It intentionally avoids runtime UI
behavior, menus, shortcuts, REST APIs, packaging logic, live E2E, packages, and
tags.

## Current Heads At Audit Start

- App `main`: `297459f`
- Build orchestration `main`: `4a8bf07`
- Build tests `main`: `b5e0735`
- Tooling docs `main`: `691869c` before this audit-report commit

Final proof must use the pushed heads that exist after this polish lands.

## Findings And Disposition

| Surface | Finding | Disposition |
|---------|---------|-------------|
| App release identity | Version, help URL, update copy, splash/About version flow, and REST status version already use the eMule BB / beta `0.7.3` line. | No runtime change. |
| App README | README still described `release/v0.72a-broadband` as the only release-intent branch and referenced Release 1.0 gates. | Fixed in app commit `297459f`. |
| Active `FEAT-056` | Summary still referenced hardening `emule-bb-v1.0.1`. | Updated to beta `0.7.3` release-proof wording. |
| Historical/deferred docs | Several archived or deferred docs still contain Release 1 / `v1.0.x` context. | Leave intact unless they become active release-control or package-facing text. |

## Evidence Policy

Fresh evidence is mandatory for final acceptance:

- Older live reports may be cited only as supporting context where `CI-035`
  classifies them.
- Existing x64 and ARM64 package manifests are rehearsal artifacts from older
  commits and are not final release hashes.
- Final x64 and ARM64 packages, manifests, SHA-256 hashes, and report paths
  must be regenerated after proof resumes on the new release-ready heads.

## Freeze Rule

After `FEAT-058` lands, the beta candidate is frozen again. Further changes
before final proof should be limited to release blockers discovered by fresh
proof, or to an explicit operator decision that resets the candidate again.
