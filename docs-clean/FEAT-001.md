---
id: FEAT-001
title: Kad FastKad — add diversity-aware bootstrap ranking and aggressive stale decay
status: Open
priority: Minor
category: feature
labels: [kad, fastkad, routing, bootstrap]
milestone: ~
created: 2026-04-08
source: AUDIT-KAD.md (AUD_KAD_004, AUD_KAD_005)
---

## Summary

`FastKad` is the local bootstrap quality cache in the target. It persists
response-time hints in `nodes.fastkad.dat` and uses recency, health, and
observed latency for bootstrap ranking. It is worth keeping and extending.

**Current weaknesses (AUD_KAD_005):**

- Bootstrap ranking is not diversity-aware — may over-prefer a dense cluster
  of once-good nodes in the same subnet.
- Long-dormant nodes can retain stale positive hints indefinitely.
- No explicit subnet balancing in bootstrap candidate selection.
- No jitter tracking — only approximate response-time spread.
- Quality is global, not segmented by operation type (bootstrap vs hello
  verification vs search).

## Protocol Compatibility

All improvements are **local policy only** — no Kad packet changes.

## Proposed Improvements

1. **Diversity bias** — when ranking bootstrap candidates, apply a per-subnet
   preference limit (e.g. max 1 preferred candidate per `/24`).
2. **Aggressive stale decay** — increase health decay rate for nodes that have
   not responded recently. Cap very old dormant sidecar influence.
3. **Jitter tracking** — add variance/jitter field alongside mean response time
   to avoid over-trusting high-variance nodes.
4. **Operation-type quality bands** — track separate quality estimates for:
   - bootstrap traffic
   - hello verification
   - search-response traffic
5. **Adaptive concurrency** — use adaptive concurrency limits in addition to
   adaptive timeout.

## Files

- `srchybrid/kademlia/utils/FastKad.h` / `FastKad.cpp`
- `srchybrid/kademlia/kademlia/Kademlia.h` / `.cpp` — bootstrap progress state
