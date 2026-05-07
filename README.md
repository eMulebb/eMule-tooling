# eMule Tooling

This repo contains the supporting documentation, helper scripts, audit
material, and central workspace policy for the current eMule workspace.

It is not the app repo and it is not the build orchestrator. The current split
is:

- app source: `repos\eMule`
- build/test orchestration: `repos\eMule-build` and `repos\eMule-build-tests`
- companion web UI: `repos\amutorrent`
- tooling docs and helpers: this repo

## Start Here

- active backlog and landed/open status:
  [`docs/active/INDEX.md`](docs/active/INDEX.md)
- long-form reference docs and topic map: [`docs/INDEX.md`](docs/INDEX.md)
- historical-reference rules for the stale experimental branch:
  [`docs/HISTORICAL-REFERENCES.md`](docs/HISTORICAL-REFERENCES.md)
- workspace-wide operating contract:
  [`docs/WORKSPACE_POLICY.md`](docs/WORKSPACE_POLICY.md)

## What This Repo Owns

- central workspace policy: [`docs/WORKSPACE_POLICY.md`](docs/WORKSPACE_POLICY.md)
- documentation ownership policy: [`docs/DOCS_POLICY.md`](docs/DOCS_POLICY.md)
- reference-doc index: [`docs/INDEX.md`](docs/INDEX.md)
- active backlog index: [`docs/active/INDEX.md`](docs/active/INDEX.md)
- broadband feature notes: [`docs/reference/FEATURE-BROADBAND.md`](docs/reference/FEATURE-BROADBAND.md)
- API server reference: [`docs/rest/PLAN-API-SERVER.md`](docs/rest/PLAN-API-SERVER.md)
- modernization roadmap: [`docs/reference/PLAN-MODERNIZATION-2026.md`](docs/reference/PLAN-MODERNIZATION-2026.md)

This repo does not own workspace materialization, app source, or build/test
execution contracts. It is the authoritative documentation home for
workspace-wide policy and the place for deeper engineering notes and helper
scripts that operate inside the canonical workspace.

Documentation is intentionally organized by document role:

- `docs/active/` = active revalidated backlog, release control, item evidence,
  execution plans, and dated review trail
- `docs/architecture/`, `docs/rest/`, and `docs/reference/` = durable technical
  and product reference
- `docs/audits/`, `docs/dependencies/`, and `docs/history/` = provenance and
  historical analysis
- `docs/ideas/` = exploratory proposals only, not active implementation plans

If a status statement in `docs/` conflicts with `docs/active`, treat
`docs/active` as authoritative for the current backlog state.

The central policy defaults to low-drift hardening and bug-fix work. Major
behavioral changes are exception work and must be explicitly justified rather
than blended into routine cleanup or modernization.

Normalization helpers live here too:

- `helpers\source-normalizer.py` checks or rewrites tracked text files to match
  repo `.editorconfig` and `.gitattributes`
- `hooks\pre-commit` is the shared workspace pre-commit hook entrypoint
- `helpers\install-editorconfig-hook.ps1` configures a target repo's local
  `core.hooksPath` to use that shared hook

## Workspace Convention

Canonical paths are expressed through `EMULE_WORKSPACE_ROOT`:

- repos live under `EMULE_WORKSPACE_ROOT\repos\...`
- app worktrees live under `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\...`

Helper scripts in this repo should follow that model and should not encode old
fixed `eMulebb` workspace paths.

For the full workspace operating contract, use
`EMULE_WORKSPACE_ROOT\repos\eMule-tooling\docs\WORKSPACE_POLICY.md`.

## Notes

- many documents here are design notes, audits, and planning artifacts rather
  than step-by-step operator guides
- references to `stale-v0.72a-experimental-clean` are preserved as historical
  provenance only; see [`docs/HISTORICAL-REFERENCES.md`](docs/HISTORICAL-REFERENCES.md)
- concrete tool-install paths may still appear in historical audit documents
  when they are part of a captured environment snapshot
