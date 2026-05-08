# Release 1.0 Stability Blockers Execution Plan

This plan owns the R1-blocking findings from the 2026-05-08 adversarial review
of current `eMule-main`. These items block `emule-bb-v1.0.0` until fixed,
validated, and reflected in their item docs.

Covered items:

- [BUG-078](../items/BUG-078.md) - qBit compatibility auth can fail open when session RNG is unavailable
- [BUG-079](../items/BUG-079.md) - WebSocket shutdown can close the termination event while accepted clients still wait on it
- [BUG-080](../items/BUG-080.md) - WebSocket shutdown can forcibly terminate the listener thread
- [BUG-081](../items/BUG-081.md) - HTTPS WebSocket handshake and read loops can spin on WANT_READ/WANT_WRITE
- [BUG-082](../items/BUG-082.md) - GeoLocation and IPFilter background refresh flags can race and remain stuck
- [BUG-083](../items/BUG-083.md) - Client UDP malformed-packet logging can read past a one-byte packet
- [BUG-084](../items/BUG-084.md) - Web admin high-level actions leak the process token handle
- [BUG-085](../items/BUG-085.md) - Kad/client UDP encryption preference gating needs Release 1 compatibility proof

## Current State

`eMule-main` was clean at review time and routine workspace validation passed.
The findings are runtime safety, shutdown, remote input, and protocol-compatibility
risks that are not covered by the static workspace policy audits.

## Sequencing

1. Fix the remote-auth blocker first: [BUG-078](../items/BUG-078.md).
2. Fix WebSocket shutdown as one coherent lifetime slice:
   [BUG-079](../items/BUG-079.md), [BUG-080](../items/BUG-080.md), and
   [BUG-081](../items/BUG-081.md).
3. Fix background refresh state ownership:
   [BUG-082](../items/BUG-082.md).
4. Fix narrow bounds and handle leaks:
   [BUG-083](../items/BUG-083.md) and [BUG-084](../items/BUG-084.md).
5. Prove or adjust Kad/client UDP encryption behavior:
   [BUG-085](../items/BUG-085.md).

Each slice must be committed and pushed before the next independent slice starts.

## Shared Implementation Rules

- Preserve legacy ED2K/Kad behavior unless the item explicitly proves a release
  blocker requires a change.
- Prefer narrow ownership fixes over broad rewrites.
- Do not replace the WebServer stack wholesale for R1.
- Keep UI-thread mutations on the UI thread, but avoid unbounded worker-to-UI
  blocking where shutdown or request storms can deadlock.
- Add targeted tests or seams for failure modes that are hard to trigger live.

## Detailed Plan

### BUG-078 - qBit session RNG fail-closed

Implementation:

- Make empty generated session IDs invalid for all protected qBit routes.
- Keep `/api/v2/auth/login` returning service unavailable when session creation
  fails.
- Reject `Cookie: SID=` and other empty SID variants even if the internal session
  string is empty.
- Add seam/unit coverage for RNG failure, empty cookie, wrong cookie, and valid
  cookie.

Validation:

- qBit login succeeds with a configured API key and working RNG.
- Protected qBit route returns forbidden/service unavailable when RNG fails.
- Native `/api/v1` authentication behavior is unchanged.

### BUG-079/080/081 - WebSocket shutdown and TLS event loops

Implementation:

- Track accepted WebSocket client threads or convert accepted clients to a
  lifetime model that can be joined/drained before closing shared termination
  state.
- Stop closing `s_hTerminate` while accepted-client threads can still wait on it.
- Remove the listener `TerminateThread` fallback; shutdown must wake, close, or
  cancel socket waits cooperatively.
- Ensure HTTPS `MBEDTLS_ERR_SSL_WANT_READ` and `MBEDTLS_ERR_SSL_WANT_WRITE`
  paths return to socket/event waits instead of tight spinning.
- Keep legacy Web UI and REST routing behavior intact.

Validation:

- Web UI disabled, enabled HTTP, and enabled HTTPS shutdown all exit cleanly.
- One idle accepted connection during shutdown does not hang or access closed
  handles.
- Slow HTTPS handshake/read simulation does not spin a CPU core.
- Existing REST malformed/concurrent matrix still passes.

### BUG-082 - background refresh state ownership

Implementation:

- Move GeoLocation and IPFilter refresh state transitions under one UI-thread
  owned or explicitly synchronized state machine.
- Set "queued/running" state before the worker can post completion, or carry an
  operation token so stale completions cannot wedge current state.
- Make thread launch failure restore idle state and remove temporary files.
- Treat failed completion posts during shutdown as terminal and do not leave
  refresh permanently queued.

Validation:

- Immediate worker failure does not leave refresh stuck as in-progress.
- Completion before the starter returns cannot leave the flag true.
- Repeated manual and automatic refresh attempts serialize correctly.

### BUG-083 - malformed client UDP logging bounds

Implementation:

- Do not read `pBuffer[1]` unless `nPacketLen >= 2`.
- Keep error logging useful for one-byte and zero-byte post-decrypt payloads.
- Preserve existing packet processing behavior for valid ED2K and Kad packets.

Validation:

- Unit/seam coverage for one-byte malformed packets.
- Live UDP packet handling remains unchanged for valid packets.

### BUG-084 - web admin token handle leak

Implementation:

- Close `hToken` on every successful `OpenProcessToken` path.
- Prefer a tiny local RAII wrapper or `wil::unique_handle` only if already
  available in the app target; otherwise keep the fix narrow.
- Preserve existing access checks and high-level action behavior.

Validation:

- Repeated web admin shutdown/reboot attempts do not increase process handle
  count.
- Failure paths still log access denied or failed as before.

### BUG-085 - Kad/client UDP encryption compatibility proof

Implementation:

- Revalidate the change that gates client UDP obfuscation on
  `thePrefs.IsCryptLayerEnabled()`.
- Compare against `release/v0.72a-community` for Kad bootstrap, Kad callback,
  LowID callback, and peer UDP behavior where the harness supports comparison.
- If disabling UDP encryption when the global crypt layer is off breaks legacy
  interoperability, restore the previous Kad-specific behavior with a narrowly
  documented exception.

Validation:

- Crypt enabled: Kad and ED2K client UDP obfuscation still works.
- Crypt disabled: behavior is either proven compatible or intentionally restored.
- LowID and buddy/callback paths do not regress.

## Release Exit Criteria

All covered items must be either:

- `Done` with commit evidence and targeted validation results, or
- explicitly reclassified by product decision in `RELEASE-1.0.md`.

R1 remains blocked while any covered item is `Open`, `In Progress`, or
unvalidated.
