---
id: FEAT-012
title: PR_TCPERRORFLOODER — TCP listen-socket flood defense
status: Open
priority: Minor
category: feature
labels: [dos, tcp, flooding, banning, security, networking]
milestone: ~
created: 2026-04-08
source: FEATURE-PEERS-BANS.md (FEAT_012)
---

## Summary

Port `CheckTCPErrorFlooder()` from eMuleAI — a defense against peers that repeatedly open TCP connections to the eMule listen socket and immediately error out (or disconnect), flooding the accept loop. This is a targeted DoS vector that doesn't require a full client handshake.

## Problem

A peer can repeatedly open and immediately close TCP connections to eMule's listen port. Each failed connection:
- Generates a `WSAECONNRESET` or similar error on the server socket
- May trigger a partial client object creation and teardown in `CClientList`
- At high rate, saturates the accept thread and can starve legitimate connections

This is distinct from normal ED2K misbehavior (which requires a handshake) — it operates entirely at the TCP layer, before any protocol bytes are exchanged.

## Detection

`PR_TCPERRORFLOODER` tracks repeated TCP error events from the same IP within a rolling time window:

```cpp
void CheckTCPErrorFlooder(uint32 uIP);  // called when a TCP accept produces an immediate error
```

Internal state per IP:
- Error event count within window
- Timestamp of first error in current window
- Escalating response threshold

When the error rate from a single IP exceeds the threshold, the IP is temporarily banned via the existing IPFilter / clientban mechanism.

## Integration Point

Call site: `CListenSocket::OnAccept()` — the lowest-level accept handler in `ListenSocket.cpp`. When `Accept()` succeeds but the resulting socket is immediately in an error state (or the client disconnects before any data arrives), call `CheckTCPErrorFlooder(remoteIP)`.

```cpp
// In CListenSocket::OnAccept():
if (!newSocket->IsConnected() || immediateError) {
    theApp.clientlist->CheckTCPErrorFlooder(remoteAddr.sin_addr.s_addr);
    delete newSocket;
    return;
}
```

The tracker lives in `CClientList` (or a dedicated `CShield` instance if FEAT-011 is also implemented — `CheckTCPErrorFlooder` is one of the `CShield` hooks).

## Configuration

- **Error threshold** (default: 10 errors / 60 seconds per IP)
- **Ban duration** (default: 5 minutes for first offense, doubling on repeat)
- **Exempt from check:** IPs in the friend list or in IPFilter "allow" ranges

Configurable via `CPPgProtectionPanel` if FEAT-011 is implemented, or via a simple preferences pair if standalone.

## Standalone vs. FEAT-011

This feature can be implemented independently of the full CShield engine (FEAT-011):
- **Standalone:** Add a `CheckTCPErrorFlooder(uint32 uIP)` method directly to `CClientList` with a `std::unordered_map<uint32, ErrorFloodState>` member.
- **With FEAT-011:** The function becomes a `CShield` hook and shares the `blacklist.conf` ban backend.

Recommend implementing standalone first, merging into CShield when FEAT-011 is done.

## Acceptance Criteria

- [ ] `CheckTCPErrorFlooder(uint32 uIP)` implemented (standalone or as CShield hook)
- [ ] Called from `CListenSocket::OnAccept()` on error/immediate-disconnect
- [ ] Threshold and ban duration configurable via preferences
- [ ] Banned IP blocked via existing ban mechanism (not a new parallel ban list)
- [ ] Log entry when an IP is banned for TCP flooding
- [ ] No false positives on legitimate clients with transient connection errors
