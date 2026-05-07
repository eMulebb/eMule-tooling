---
id: AMUT-001
title: aMuTorrent eMule BB browser smoke coverage
status: Passed
priority: Major
category: integration
labels: [amutorrent, rest, ui-smoke, controller]
milestone: broadband-release
created: 2026-05-02
source: broadband release live E2E and REST completeness planning
---

## Summary

Add a browser smoke lane that runs aMuTorrent against a live eMule BB instance.

## Release 1.0 Classification

**Release Gate.** Full E2E-validated integration with aMuTorrent and the Arr
suite is part of Release 1. This item owns the aMuTorrent side of that gate:
at least one browser smoke against a live instance with request and console
artifacts.

## Execution Plan

Covered by the [Release 1.0 REST and Arr execution plan](../plans/RELEASE-1.0-REST-ARR-EXECUTION-PLAN.md).

## Acceptance Criteria

- [x] aMuTorrent can connect to the eMule BB REST API with configured host,
      port, and API key
- [x] dashboard connection state renders eD2K and Kad status
- [x] transfers, shared files, shared directories, categories, searches, and
      uploads render without adapter exceptions
- [x] create/delete category and shared-directory reload flows are exercised
      through the browser smoke where supported
- [x] failures produce browser console and REST request artifacts

## Completion Evidence

- tests: `affc4d6`, `11365ca`
- command: `python -m pytest tests\python\test_amutorrent_browser_smoke.py tests\python\test_live_e2e_suite.py -q`
- command: `pwsh -File repos\eMule-build\workspace.ps1 live-e2e -Config Release -Platform x64 -LiveSuite amutorrent-browser-smoke`
- artifact: `repos\eMule-build-tests\reports\amutorrent-browser-smoke\20260506-193606-eMule-main-release\result.json`
- aggregate: `repos\eMule-build-tests\reports\live-e2e-suite\20260506-193606-eMule-main-release\result.json`

## Relationship To Other Items

- backs `CI-011`
- complements `ARR-001`
- consumes the native REST contract owned by `FEAT-013` and follow-up items
