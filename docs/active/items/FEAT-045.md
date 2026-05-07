---
id: FEAT-045
title: REST transfer detail endpoint for controller parity
status: Open
priority: Major
category: feature
labels: [rest, transfers, controller, amutorrent]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Add a transfer detail endpoint for controller views that need more than the
current transfer row plus source list.

## Release 1.0 Classification

**Release Candidate.** Pull this into the 1.0 gate only if the aMuTorrent smoke
proves the current transfer row plus source list cannot provide useful release
views. Otherwise keep it as a documented 1.1 controller-parity follow-up.

Target route:

- `GET /api/v1/transfers/{hash}/details`

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](../plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Current Gap

The REST API already exposes transfer rows and
`GET /api/v1/transfers/{hash}/sources`. aMuTorrent still has placeholders for
segment-oriented fields such as `partStatus`, `gapStatus`, and `reqStatus`
because the backend does not expose an equivalent detail payload yet.

## Acceptance Criteria

- [ ] detail data is exposed through a dedicated endpoint, not by bloating
      `snapshot`
- [ ] missing or malformed hashes return the stable REST error envelope
- [ ] the endpoint is covered by native route tests, live REST smoke, and the
      contract manifest
- [ ] aMuTorrent consumes the endpoint when capability metadata indicates it is
      available

## Relationship To Other Items

- feeds `AMUT-002`
- updates `CI-014`
