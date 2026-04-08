---
id: FEAT-002
title: Kad SafeKad — evolve from coarse same-IP gate into layered trust model (CGNAT fix)
status: Open
priority: Major
category: feature
labels: [kad, safekad, routing, cgnat, trust]
milestone: ~
created: 2026-04-08
source: AUDIT-KAD.md (AUD_KAD_006, AUD_KAD_007)
---

## Summary

`SafeKad` is the local Kad anti-abuse layer. It currently enforces near-"one
routed node per public IP" semantics. This is effective against simple Sybil
stuffing but is too blunt for modern NAT-heavy networks:

- **CGNAT** — mobile carriers share a single public IP across thousands of users
- **Enterprise NAT** — large offices appear as one IP
- **Campus NAT** — universities, ISPs

The result is that legitimate peers are rejected in dense NAT environments,
degrading route diversity unintentionally.

## Current Hard-Gate Behaviour (AUD_KAD_006)

A contact from an already-seen IP is rejected at routing admission. There is
no probation, no port-differentiation, no density-aware fallback.

## Proposed Layered Trust Model (AUD_KAD_007)

Replace the hard gate with a graduated policy:

| Signal | Action |
|--------|--------|
| New contact, unseen IP | Normal admission |
| New contact, same IP, different UDP port, stable behaviour | Admit to **probation** — not preferred for routing but not rejected |
| Probationary contact passes N successful verified interactions | **Promote** to normal routing trust |
| Same-IP contact shows ID flipping | **Hard ban** for ID-flip signal |
| Repeated malformed expensive requests | **Hard ban** |
| Repeated flood behaviour | **Hard ban** |

### Principle: Diversity as Preference, Not Hard Gate

- Use one good contact per IP per bucket as a **preference**, not a global rule.
- "Not preferred for routing" ≠ "completely rejected".
- Hard bans reserved only for the strongest abuse signals.

## Protocol Compatibility

All changes are local policy — no Kad packet changes, no wire format changes.

## Files

- `srchybrid/kademlia/utils/SafeKad.h` / `SafeKad.cpp`
- `srchybrid/kademlia/routing/RoutingZone.h` / `.cpp` — admission integration
- `srchybrid/kademlia/kademlia/Kademlia.h` / `.cpp` — verification integration
