# Documentation Policy

This repo keeps all Markdown under `docs/`. Document role is determined by
path, not by filename alone.

## Active Docs

`docs/active/` owns current backlog and release truth:

- `docs/active/INDEX.md`: active backlog dashboard and item tables
- `docs/active/RELEASE-0.7.3*.md`: Beta release control, checklist, runbook,
  and release operator docs
- `docs/active/items/`: active item records for Open, In Progress, Blocked,
  and Deferred work
- `docs/active/plans/`: the single current beta release execution plan

If another doc conflicts with `docs/active/`, `docs/active/` wins for current
status.

## Reference Docs

- `docs/architecture/`: durable architecture notes
- `docs/rest/`: current REST contract and API reference
- `docs/reference/`: durable current product guides and specialist references
- `docs/dependencies/`: current dependency health and decision records
- `docs/history/`: closed item records, dated review findings, historical
  comparisons, source salvage, old ledgers, dated audits, stale dependency
  analysis, and superseded release plans

Reference docs may preserve historical branch names, old paths, and old
decisions as provenance, but they do not override active status.

## Ideas

`docs/ideas/` contains exploratory proposals only. These documents are not
active implementation plans and must not be treated as current release scope or
current branch direction unless a future active item explicitly promotes a
specific slice.

Examples: CMake adoption and Boost adoption.

## Writing Rules

- Keep current decisions in `docs/active/`, not in historical reference docs.
- Move closed item records (Done, Passed, Wont-Fix) to `docs/history/items/`.
- Move dated review reports to `docs/history/reviews/` after they stop driving
  active execution.
- Move stale audit reports to `docs/history/audits/`; move release-specific
  audit snapshots under that release's `docs/history/release-*` folder.
- Prefix historical analysis files outside the standard closed-item/review
  folders with `HIST-`; prefix speculative proposals with `IDEA-`.
- Keep the current release execution sequence in one active plan. Superseded
  release cluster plans belong under `docs/history/`.
- Every actionable active task must have its own item ID under
  `docs/active/items/`; release dashboards and plans should point to item IDs
  instead of carrying anonymous task rows.
- Do not create new top-level Markdown files in `docs/` unless they are policy
  or navigation entry points.
- Add new exploratory proposals under `docs/ideas/` with an explicit
  exploratory-only banner.
