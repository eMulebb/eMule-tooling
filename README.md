# eMule Tooling

This repo contains the supporting documentation, helper scripts, and audit
material for the current eMule workspace.

It is not the app repo and it is not the build orchestrator. The current split
is:

- app source: `repos\eMule`
- build/test orchestration: `repos\eMule-build` and `repos\eMule-build-tests`
- remote companion app: `repos\eMule-remote`
- tooling docs and helpers: this repo

## Key Documents

- doc index: [`docs/INDEX.md`](docs/INDEX.md)
- broadband feature notes: [`docs/FEATURE-BROADBAND.md`](docs/FEATURE-BROADBAND.md)
- API server contract: [`docs/PLAN-API-SERVER.md`](docs/PLAN-API-SERVER.md)
- modernization roadmap: [`docs/PLAN-MODERNIZATION-2026.md`](docs/PLAN-MODERNIZATION-2026.md)

## Workspace Model

Canonical paths are expressed through `EMULE_WORKSPACE_ROOT`:

- repos live under `EMULE_WORKSPACE_ROOT\repos\...`
- app worktrees live under `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\...`

Helper scripts in this repo should follow that model and should not encode old
fixed `eMulebb` workspace paths.

## Notes

- many documents here are design notes, audits, and planning artifacts rather
  than step-by-step operator guides
- concrete tool-install paths may still appear in historical audit documents
  when they are part of a captured environment snapshot
