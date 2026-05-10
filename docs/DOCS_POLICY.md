# Documentation Policy

This repo keeps all Markdown under `docs/`. Document role is determined by
path, not by filename alone.

## Active Docs

`docs/active/` owns current backlog and Release 1 truth:

- `docs/active/INDEX.md`: active backlog dashboard and item tables
- `docs/active/RELEASE-0.7.3*.md`: Beta release control, checklist, runbook,
  gate history, and release-specific plans
- `docs/active/items/`: item records, acceptance criteria, and evidence
- `docs/active/plans/`: execution plans for closing or revalidating work
- `docs/active/reviews/`: dated revalidation and review findings

If another doc conflicts with `docs/active/`, `docs/active/` wins for current
status.

## Reference Docs

- `docs/architecture/`: durable architecture notes
- `docs/rest/`: REST contract and API reference
- `docs/reference/`: durable product, feature, guide, and modernization
  background
- `docs/audits/`: audit reports and static analysis provenance
- `docs/dependencies/`: dependency health and dependency-change analysis
- `docs/history/`: historical comparisons, source salvage, and old ledgers

Reference docs may preserve historical branch names, old paths, and old
decisions as provenance, but they do not override active status.

## Ideas

`docs/ideas/` contains exploratory proposals only. These documents are not
active implementation plans and must not be treated as Release 1 scope or
current branch direction unless a future active item explicitly promotes a
specific slice.

Examples: CMake adoption and Boost adoption.

## Writing Rules

- Keep current decisions in `docs/active/`, not in historical reference docs.
- Keep execution details in `docs/active/plans/`; item docs should link to the
  owning plan instead of duplicating strategy.
- Do not create new top-level Markdown files in `docs/` unless they are policy
  or navigation entry points.
- Add new exploratory proposals under `docs/ideas/` with an explicit
  exploratory-only banner.
