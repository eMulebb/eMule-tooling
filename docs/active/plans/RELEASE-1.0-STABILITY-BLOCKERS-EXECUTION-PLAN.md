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
- [BUG-086](../items/BUG-086.md) - HTTPS WebSocket casts SOCKET storage to mbedtls_net_context
- [BUG-087](../items/BUG-087.md) - HTTPS WebSocket queued writes can stall after TLS WANT_READ
- [BUG-088](../items/BUG-088.md) - WebSocket timeout shutdown leaves global state unsafe for restart
- [BUG-089](../items/BUG-089.md) - UDP control sender can deadlock on exception while holding sendLocker
- [BUG-090](../items/BUG-090.md) - Background refresh completion can wedge when UI PostMessage fails
- [BUG-091](../items/BUG-091.md) - DirectDownload ignores close-time write failures

## Current State

`eMule-main` was clean at the 2026-05-08 follow-up review time. The original
R1 stability items through [BUG-085](../items/BUG-085.md) are done on `main`,
but the follow-up adversarial pass found additional runtime safety, shutdown,
remote input, and persistence risks that are not covered by the static workspace
policy audits.

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
6. Fix the remaining HTTPS WebSocket transport and shutdown restart blockers:
   [BUG-087](../items/BUG-087.md) and [BUG-088](../items/BUG-088.md).
7. Fix the UDP control sender exception-safety blocker:
   [BUG-089](../items/BUG-089.md).
8. Fix the remaining background refresh completion-delivery blocker:
   [BUG-090](../items/BUG-090.md).
9. Fix the direct-download close-time persistence blocker:
   [BUG-091](../items/BUG-091.md).

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

Status:

- Done 2026-05-08 in app commit `02fd5bf` and test commit `dfc86d6`.
- Validated with workspace `validate`, Release x64 main test build, focused
  qBit cookie doctest, and Release x64 main app build.

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

Status:

- BUG-079, BUG-080, and BUG-081 are done 2026-05-08 in app commit `aa66699`.
- Validated with workspace `validate` and Release x64 main app build.
- The implementation tracks accepted-client thread objects until join/reap,
  closes `s_hTerminate` only after socket threads are drained, removes the
  listener `TerminateThread` fallback, and moves HTTPS WANT paths back to socket
  readiness or queued sends instead of tight loops.

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

Status:

- Done 2026-05-08 in app commit `e5c8f81`.
- Validated with workspace `validate` and Release x64 main app build.
- GeoLocation and IPFilter refresh workers now start suspended, mark queued
  before they can run, clear the flag on launch failure, and transfer the
  context before resuming the worker.

### BUG-083 - malformed client UDP logging bounds

Implementation:

- Do not read `pBuffer[1]` unless `nPacketLen >= 2`.
- Keep error logging useful for one-byte and zero-byte post-decrypt payloads.
- Preserve existing packet processing behavior for valid ED2K and Kad packets.

Validation:

- Unit/seam coverage for one-byte malformed packets.
- Live UDP packet handling remains unchanged for valid packets.

Status:

- Done 2026-05-08 in app commit `1af8bb5` and test commit `cfe9b96`.
- Validated with workspace `validate`, Release x64 main app build, Release x64
  main test build, and the focused Client UDP opcode logging doctest.

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

Status:

- Done 2026-05-08 in app commit `1513358`.
- Validated with workspace `validate` and Release x64 main app build.
- The web high-level action path now wraps the process token in a local RAII
  guard so the token handle closes on normal and exception exits.

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

Status:

- Done 2026-05-08 in app commit `2ee49ab` and test commit `2d5cc1a`.
- Validated with workspace `validate`, Release x64 main app build, Release x64
  main test build, and the focused Client UDP crypt gating doctest.
- Release 1 behavior is explicitly documented and tested: outgoing ED2K and Kad
  client UDP obfuscation follows the global crypt-layer preference; crypt
  disabled keeps new outgoing client UDP sends plain while inbound encrypted
  datagrams remain accepted by the encrypted datagram receive path.

### BUG-086 - HTTPS WebSocket mbedTLS socket context ABI

Implementation:

- Replace the casted `SOCKET` storage with an actual transport context that
  preserves the full WinSock socket value on supported 64-bit builds.
- Prefer narrow local mbedTLS send/recv/close callbacks if the pinned
  `mbedtls_net_context` ABI cannot represent Windows `SOCKET` safely.
- Make accepted-client socket ownership explicit so exactly one close path owns
  each accepted socket.
- Keep plain HTTP behavior unchanged.

Validation:

- HTTPS Web UI/REST smoke succeeds on x64.
- Socket close paths do not truncate or double-close accepted sockets.
- Shutdown coverage still passes after the transport context change.

Status:

- Done 2026-05-08 in app commit `c6c1526`.
- Validated with workspace `validate` and Release x64 main app build.
- The implementation replaces the casted mbedTLS net context with
  WebSocket-owned WinSock send/recv callbacks and closes accepted sockets
  through the explicit accepted-thread cleanup path.

### BUG-087 - HTTPS WebSocket queued TLS writes after WANT_READ

Implementation:

- Track whether the pending TLS operation needs read readiness, write readiness,
  or either.
- Retry queued HTTPS writes after the readiness condition requested by mbedTLS,
  including `MBEDTLS_ERR_SSL_WANT_READ`.
- Return to socket/event waits between retries to avoid CPU spin.
- Preserve existing queued-send ordering.

Validation:

- Seam coverage for a queued HTTPS write that returns `WANT_READ` before
  completion.
- Slow HTTPS client shutdown does not leave an accepted thread stuck with
  `m_pHead` queued.
- Existing REST malformed/concurrent request coverage remains green.

Status:

- Open. Blocks R1.

### BUG-088 - WebSocket shutdown timeout restart safety

Implementation:

- Define explicit stopped/running/stopping/failed-stopping subsystem states.
- Make `StartSockets` fail closed in release builds if previous shutdown left
  live listener, accepted-thread, termination-handle, or SSL state behind.
- Prevent overwriting live global handles or SSL state.
- Add diagnostics that identify the thread class preventing shutdown.

Validation:

- Simulated listener wait timeout cannot be followed by unsafe restart.
- Simulated accepted-client wait timeout cannot be followed by unsafe restart.
- Successful HTTP and HTTPS stop/start cycles still work.

Status:

- Open. Blocks R1.

### BUG-089 - UDP control sender exception safety

Implementation:

- Replace manual `sendLocker.Lock()`/`Unlock()` with scoped locking compatible
  with existing MFC synchronization.
- Make removed `UDPPack` and temporary send buffer ownership exception-safe.
- Preserve packet ordering, resend-on-send-failure, and throttler signaling
  semantics.

Validation:

- Injected allocation or send failure releases `sendLocker`.
- Removed packets are sent, requeued, or destroyed exactly once.
- Client UDP crypt-gating seam remains green.

Status:

- Open. Blocks R1.

### BUG-090 - background refresh completion delivery

Implementation:

- Treat successful UI `PostMessage` as transferring completion ownership to the
  UI thread.
- Treat failed `PostMessage` as terminal cleanup or a deterministic shutdown
  state; do not leave refresh permanently queued.
- Handle `ResumeThread` failure so a never-started worker cannot wedge state.
- Apply the same ownership model to GeoLocation and IPFilter refresh.

Validation:

- Failed completion post clears or terminally resolves GeoLocation refresh.
- Failed completion post clears or terminally resolves IPFilter refresh.
- Manual and automatic refresh attempts still serialize.

Status:

- Open. Blocks R1.

### BUG-091 - DirectDownload close-time persistence failure

Implementation:

- Check `_close` after the download write loop and treat failure as a download
  failure.
- Preserve close-time `errno` for diagnostics before cleanup.
- Delete failed artifacts just like earlier read/write failures.
- Confirm GeoLocation and IPFilter callers do not promote failed artifacts.

Validation:

- Seam coverage for successful `_write` followed by failed `_close`.
- GeoLocation and IPFilter update flows reject failed artifacts.
- Existing successful direct-download behavior is unchanged.

Status:

- Open. Blocks R1.

## Release Exit Criteria

All covered items must be either:

- `Done` with commit evidence and targeted validation results, or
- explicitly reclassified by product decision in `RELEASE-1.0.md`.

As of the 2026-05-08 follow-up review, [BUG-087](../items/BUG-087.md) through
[BUG-091](../items/BUG-091.md) are open R1 blockers. R1 must not tag until they
are fixed or explicitly reclassified by product decision.
