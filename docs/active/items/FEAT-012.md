---
id: FEAT-012
title: PR_TCPERRORFLOODER — TCP listen-socket flood defense
status: Done
priority: Minor
category: feature
labels: [dos, tcp, flooding, banning, security, networking]
milestone: ~
created: 2026-04-08
source: FEATURE-PEERS-BANS.md (FEAT_012)
---

## Summary

`main` now includes a standalone stock-friendly `CheckTCPErrorFlooder(uint32)` defense in `CClientList`.

It detects repeated accepted incoming TCP sockets from the same IP which die before any protocol packet is received, then reuses the existing banned-IP path instead of importing the wider eMuleAI `CShield` punishment system.

## Problem

A peer can repeatedly open and immediately close TCP connections to eMule's listen port. Each failed connection:
- Generates a `WSAECONNRESET` or similar error on the server socket
- May trigger a partial client object creation and teardown in `CClientList`
- At high rate, saturates the accept thread and can starve legitimate connections

This is distinct from normal ED2K misbehavior (which requires a handshake) — it operates entirely at the TCP layer, before any protocol bytes are exchanged.

## Detection

The standalone tracker counts repeated pre-handshake TCP error/close events from the same IP within a rolling time window:

```cpp
void CheckTCPErrorFlooder(uint32 uIP);  // called when a TCP accept produces an immediate error
```

Internal state per IP:
- Error event count within window
- Timestamp of first event in current window
- Last-seen timestamp for cleanup

When the error rate from a single IP exceeds the threshold, the IP is banned via the existing stock `AddBannedClient()` path and current `CLIENTBANTIME`.

## Integration Point

Current `main` does **not** attribute raw `Accept()` failures to peer IPs. The landed hook therefore lives on the accepted socket’s early failure path:

- `CClientReqSocket::OnError()`
- `CClientReqSocket::OnClose()`

The check runs only for accepted incoming sockets which:
- have no attached `CUpDownClient`
- have not received their first protocol packet
- are not port-test connections
- have not already been counted once for the same socket lifetime

The tracker lives in `CClientList` and remains standalone.

## Configuration

- `DetectTCPErrorFlooder` (default: `true`)
- `TCPErrorFlooderIntervalMinutes` (default: `60`)
- `TCPErrorFlooderThreshold` (default: `10`)

These are exposed in `Preferences -> Tweaks -> Hidden security and messaging`.

## Standalone vs. FEAT-011

This landed independently of the full `CShield` engine (`FEAT-011`):
- **Standalone mainline implementation:** `CClientList::CheckTCPErrorFlooder(uint32 uIP)` with an internal per-IP tracker map
- **Not imported:** `CShield`, punishment categories, `blacklist.conf`, or protection-panel UI

If `FEAT-011` is ever pursued later, `PR_TCPERRORFLOODER` can be re-homed into that engine, but the current standalone implementation is sufficient and stock-preserving.

## Acceptance Criteria

- [x] `CheckTCPErrorFlooder(uint32 uIP)` implemented standalone in `CClientList`
- [x] Called from accepted-socket `OnError()` / `OnClose()` on pre-handshake failure
- [x] Detection toggle, interval, and threshold configurable via preferences
- [x] Banned IP blocked via existing stock banned-IP mechanism
- [x] Log entry emitted when an IP is banned for TCP flooding
- [x] First-packet and one-shot socket guards prevent double-counting and avoid counting normal post-handshake errors
