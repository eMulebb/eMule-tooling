# eMule Documentation Index

This directory is the single Markdown home for the tooling repo. Use
[DOCS_POLICY](DOCS_POLICY.md) for ownership rules.

## Start Here

| Need | Primary Doc |
|---|---|
| Workspace policy | [WORKSPACE_POLICY](WORKSPACE_POLICY.md) |
| Active backlog and Release 1 status | [active/INDEX](active/INDEX.md) |
| Documentation ownership rules | [DOCS_POLICY](DOCS_POLICY.md) |
| Historical-reference rules | [HISTORICAL-REFERENCES](HISTORICAL-REFERENCES.md) |
| Repo-level navigation | [../README](../README.md) |

If a status claim outside `docs/active/` conflicts with `docs/active/`, treat
`docs/active/` as authoritative for current backlog and release state.

## Active Work

| Document | Description |
|---|---|
| [active/INDEX](active/INDEX.md) | Active backlog dashboard and item tables |
| [active/RELEASE-1.0](active/RELEASE-1.0.md) | Release 1 control document |
| [active/RELEASE-1.0-CHECKLIST](active/RELEASE-1.0-CHECKLIST.md) | Release operator checklist |
| [active/RELEASE-1.0-RUNBOOK](active/RELEASE-1.0-RUNBOOK.md) | Release operator runbook |
| [active/plans/](active/plans/) | Release execution plans |
| [active/items/](active/items/) | Backlog item records |
| [active/reviews/](active/reviews/) | Dated revalidation reviews |

## Reference Families

| Folder | Role |
|---|---|
| [architecture/](architecture/) | Durable architecture notes |
| [audits/](audits/) | Audit reports and static-analysis provenance |
| [dependencies/](dependencies/) | Dependency health and dependency-change analysis |
| [history/](history/) | Historical comparisons, source salvage, and old ledgers |
| [ideas/](ideas/) | Exploratory proposals only, not active implementation plans |
| [reference/](reference/) | Product, feature, guide, and modernization background |
| [rest/](rest/) | REST contract and API reference |

## Common References

| Document | Description |
|---|---|
| [architecture/ARCH-NETWORKING](architecture/ARCH-NETWORKING.md) | Networking-stack reference |
| [architecture/ARCH-PREFERENCES](architecture/ARCH-PREFERENCES.md) | Preference architecture and compatibility policy |
| [architecture/PREFERENCE-SURFACE-MATRIX](architecture/PREFERENCE-SURFACE-MATRIX.md) | Active preference key/default/range/UI/REST matrix |
| [reference/FEATURE-BROADBAND](reference/FEATURE-BROADBAND.md) | Broadband controller design background |
| [reference/GUIDE-LONGPATHS](reference/GUIDE-LONGPATHS.md) | Long-path implementation guide |
| [rest/REST-API-CONTRACT](rest/REST-API-CONTRACT.md) | Human-readable broadband REST contract |
| [rest/REST-API-OPENAPI](rest/REST-API-OPENAPI.yaml) | Canonical machine-readable `/api/v1` OpenAPI contract |
| [rest/REST-API-PARITY-INVENTORY](rest/REST-API-PARITY-INVENTORY.md) | Legacy WebServer runtime-action parity checklist |

## Exploratory Ideas

| Document | Description |
|---|---|
| [ideas/IDEA-BOOST](ideas/IDEA-BOOST.md) | Exploratory Boost/POCO adoption idea; not an active plan |
| [ideas/IDEA-CMAKE](ideas/IDEA-CMAKE.md) | Exploratory CMake/Ninja adoption idea; not an active plan |

## Notes

- Historical branch names such as `stale-v0.72a-experimental-clean` and old
  branch labels may appear in reference docs as provenance only.
- Preserve commit ids and historical branch names where they add provenance,
  but do not treat them as current-branch guidance unless `docs/active/`
  explicitly says the work is landed on `main`.
