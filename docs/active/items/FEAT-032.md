---
id: FEAT-032
title: NAT mapping modernization — keep MiniUPnP, drop WinServ, add PCP/NAT-PMP
status: Deferred
priority: Minor
category: feature
labels: [networking, upnp, nat-pmp, pcp, miniupnp, preferences]
milestone: ~
created: 2026-04-20
source: 2026-04-20 UPnP robustness review plus PCP/NAT-PMP dependency follow-through
---

## Summary

Current `main` historically carried two UPnP codepaths:

- `miniupnpc` for `UPnP IGD`
- legacy Windows-service/COM discovery and mapping in `UPnPImplWinServ`

That mixed stack is noisy and hard to reason about in practice. Typical logs
show MiniUPnP finding a valid IGD, then an unrelated Windows-service fallback
failure that does not help the operator understand what actually happened.

`FEAT-032` modernizes the NAT-mapping stack by:

- keeping `miniupnpc` as the `UPnP IGD` backend
- removing the legacy Windows-service/COM backend
- adding `libpcpnatpmp` as a second protocol-family backend for `PCP` /
  `NAT-PMP`
- exposing a new Tweaks backend-mode selector

## Release 1.0 Classification

**Release Candidate.** The code/build slice is already complete, so 1.0 should
take the live NAT validation if the available network can prove it cleanly.
Do not block `emule-bb-v1.0.0` solely because the local network cannot provide
a PCP/NAT-PMP-capable path.

## Execution Plan

Covered by the [Release 1.0 NAT Mapping execution plan](../plans/RELEASE-1.0-NAT-MAPPING-EXECUTION-PLAN.md).

## Acceptance Criteria

- [x] `UPnPImplWinServ` removed from the app build
- [x] `miniupnpc` remains the `UPnP IGD` backend
- [x] `libpcpnatpmp` is linked into the supported app build
- [x] Tweaks exposes `Automatic` / `UPnP IGD only` / `PCP/NAT-PMP only`
- [x] native tests cover `Automatic` as UPnP IGD first, then PCP/NAT-PMP
- [x] WinServ-only active prefs are removed from runtime behavior
- [x] supported `eMule-build` app builds pass for active architectures
- [ ] live-network NAT-mapping validation completed on current `main`

## Release 1 Decision

Deferred for Release 1 live proof. The code/build slice is accepted by the
release plan, but available release validation must not block the tag solely on
the absence of a PCP/NAT-PMP-capable network. Complete the remaining live proof
when a suitable router or lab network can exercise MiniUPnP success,
PCP/NAT-PMP fallback, explicit PCP/NAT-PMP-only mode, and WebServer TCP mapping.
