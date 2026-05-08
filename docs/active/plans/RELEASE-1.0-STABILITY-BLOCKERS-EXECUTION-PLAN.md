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
- [BUG-092](../items/BUG-092.md) - Background refresh workers can write through freed owner memory after shutdown
- [BUG-093](../items/BUG-093.md) - Failed refresh completion can synchronously block worker on UI thread
- [BUG-094](../items/BUG-094.md) - ResumeThread failure leaks suspended refresh thread objects
- [BUG-095](../items/BUG-095.md) - WebSocket accepted-client tracking is not exception-safe after thread start
- [BUG-096](../items/BUG-096.md) - DirectDownload lacks bounded timeout and cancellation contract
- [BUG-097](../items/BUG-097.md) - Startup-cache save worker can outlive shared-file list owner
- [BUG-074](../items/BUG-074.md) - Archive preview scanner uses volatile cancellation and synchronous UI handoff
- [BUG-098](../items/BUG-098.md) - Archive recovery worker uses raw part-file owner across async work
- [BUG-099](../items/BUG-099.md) - WebSocket listener startup is not exception-safe after global state initialization
- [BUG-100](../items/BUG-100.md) - DirectDownload has bounded timeouts but no hard owner cancellation contract

## Current State

`eMule-main` was clean at the 2026-05-08 follow-up review time. The original
R1 stability items through [BUG-096](../items/BUG-096.md) are done on `main`.
The latest follow-up adversarial pass promoted three R1 blockers.
[BUG-097](../items/BUG-097.md) and [BUG-099](../items/BUG-099.md) are now done on
`main`; [BUG-100](../items/BUG-100.md) remains open. Archive preview and recovery findings
[BUG-074](../items/BUG-074.md) and [BUG-098](../items/BUG-098.md) are Wont-Fix
by product decision because those deprecated features are entirely frozen,
including known bugs.

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
6. Close the refresh shutdown use-after-free and synchronous UI handoff as one
   coherent lifetime slice: [BUG-092](../items/BUG-092.md) and
   [BUG-093](../items/BUG-093.md).
7. Close the refresh launch-failure leak in the same owner/context model:
   [BUG-094](../items/BUG-094.md).
8. Close WebSocket accepted-client tracking exception safety:
   [BUG-095](../items/BUG-095.md).
9. Add bounded timeout or cancellation semantics for refresh downloads:
   [BUG-096](../items/BUG-096.md).
10. Close startup-cache save worker lifetime:
    [BUG-097](../items/BUG-097.md).
11. Do not implement archive preview or recovery bug fixes while those
    deprecated features are frozen; keep [BUG-074](../items/BUG-074.md) and
    [BUG-098](../items/BUG-098.md) marked Wont-Fix unless explicitly unfrozen.
12. Close WebSocket listener startup exception safety:
    [BUG-099](../items/BUG-099.md).
13. Add hard owner cancellation for background direct downloads:
    [BUG-100](../items/BUG-100.md).
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

- Done 2026-05-08 in app commit `dfcf1fe`.
- Validated with workspace `validate` and Release x64 main app build.
- The implementation centralizes queued-send draining and retries HTTPS queued
  writes after read readiness so TLS `WANT_READ` progress no longer depends on a
  later `FD_WRITE` event.

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

- Done 2026-05-08 in app commit `7a5de38`.
- Validated with workspace `validate` and Release x64 main app build.
- Startup now attempts to complete deferred shutdown cleanup and otherwise
  refuses to overwrite live WebSocket listener, accepted-client, or termination
  state in release builds.

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

- Done 2026-05-08 in app commit `4796d2f`.
- Validated with workspace `validate`, Release x64 main app build, Release x64
  main test build, and the focused Client UDP crypt-gating doctest.
- The implementation uses scoped locking and scoped packet/send-buffer
  ownership in `SendControlData`, with exception logging instead of leaving
  `sendLocker` held.

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

- Done 2026-05-08 in app commit `1a09692`.
- Validated with workspace `validate`, Release x64 main app build, Release x64
  main test build, and the focused IP-filter refresh seam doctest.
- GeoLocation and IPFilter refresh flags now use interlocked state, failed
  completion posts fall back to synchronous delivery when possible, and a missing
  notify window clears the queued flag instead of wedging refresh state.

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

- Done 2026-05-08 in app commit `c237d48`.
- Validated with workspace `validate`, Release x64 main app build, Release x64
  main test build, and the focused IP-filter update payload doctest.
- `DirectDownload::DownloadUrlToFile` now treats `_close` failure as a download
  failure and deletes the target artifact like earlier read/write failures.

### BUG-092 - background refresh worker owner lifetime

Implementation:

- Remove raw worker-context pointers into `CGeoLocation` and
  `CIPFilterUpdater` member storage, or replace them with an explicitly owned
  completion/lifetime token.
- If refresh workers remain owner-managed, make owner destruction cancel and
  join outstanding workers before the owner memory is released.
- Ensure normal completion, failed UI notification, and shutdown cleanup consume
  the refresh context exactly once.
- Preserve manual and scheduled refresh serialization.

Validation:

- Completion after owner shutdown cannot write through freed owner memory.
- Failed notification delivery cannot leave the refresh state wedged.
- GeoLocation and IPFilter refresh success paths still promote valid artifacts.

Status:

- Done 2026-05-08 in app commit `cfb0625`.
- Validated with workspace `validate`, Release x64 main app build, and Debug
  x64 main app build.
- GeoLocation and IPFilter refresh workers now hold shared heap-owned refresh
  state instead of raw pointers into owner member storage, so fallback cleanup
  after owner destruction cannot write through freed owner memory.

### BUG-093 - refresh completion synchronous UI fallback

Implementation:

- Remove worker-thread `SendMessage` fallback from GeoLocation and IPFilter
  refresh completion delivery.
- Treat successful `PostMessage` as the only UI-thread ownership transfer.
- Treat failed post as deterministic terminal cleanup, or route it through the
  owner cancellation/join model from [BUG-092](../items/BUG-092.md).
- Keep UI-owned state transitions on the UI thread without blocking worker
  threads on the UI message pump.

Validation:

- Simulated failed `PostMessage` does not call the completion handler through
  worker-thread `SendMessage`.
- Simulated blocked UI or shutdown cannot deadlock a refresh worker.
- Refresh can be retried after failed completion delivery.

Status:

- Done 2026-05-08 in app commit `2823a5c`.
- Validated with workspace `validate`, Release x64 main app build, and Debug
  x64 main app build.
- GeoLocation and IPFilter refresh workers no longer call `SendMessage` after
  failed `PostMessage`; failed completion delivery clears the shared refresh
  state and logs without synchronously blocking on the UI thread.

### BUG-094 - refresh ResumeThread failure cleanup

Implementation:

- Keep explicit ownership of suspended `CWinThread` objects until
  `ResumeThread` succeeds.
- Do not release refresh context ownership to a worker that never starts.
- On resume failure, close/delete the suspended thread object using the correct
  MFC ownership contract, reset refresh state, and remove any attempted
  temporary artifact.
- Apply the same launch-failure model to GeoLocation and IPFilter.

Validation:

- Injected `ResumeThread` failure leaves no suspended thread handle or
  `CWinThread` object behind.
- Refresh state is idle after launch failure.
- Successful worker start remains unchanged.

Status:

- Done 2026-05-08 in app commit `e5d770e`.
- Validated with workspace `validate`, Release x64 main app build, and Debug
  x64 main app build.
- GeoLocation and IPFilter refresh launch failure now captures the original
  `ResumeThread` error, releases the never-resumed suspended MFC worker object,
  resets refresh state, and removes temporary artifacts.

### BUG-095 - WebSocket accepted-client tracking exception safety

Implementation:

- Make accepted-client thread tracking succeed before the thread can run, or
  guard the started thread, socket, and SSL state until tracking succeeds.
- If tracking allocation fails after thread creation, signal/close/join the
  accepted client deterministically.
- Keep accepted-client drain, shutdown, and restart-safety behavior from the
  existing R1 WebSocket fixes.

Validation:

- Injected allocation failure in accepted-thread tracking cannot leave a running
  untracked accepted client.
- HTTP and HTTPS accepted-client shutdown still drains tracked clients.
- WebSocket restart refusal still protects against incomplete shutdown.

Status:

- Done 2026-05-08 in app commit `219be75`.
- Validated with workspace `validate`, Release x64 main app build, and Debug
  x64 main app build.
- Accepted WebSocket client threads are now inserted into the tracked-thread
  list before `CreateThread` starts them; if tracking allocation fails, no
  accepted-client thread has started and the accept path cleans up locally.

### BUG-096 - DirectDownload timeout and cancellation contract

Implementation:

- Add bounded WinInet timeout behavior for background refresh downloads, or pass
  an explicit cancellation/shutdown event into refresh downloads.
- Keep successful download, proxy, temp-file cleanup, and BUG-091 close-time
  persistence behavior compatible.
- Define the timeout/cancellation contract in the DirectDownload call surface or
  a narrow options structure rather than relying on implicit WinInet defaults.

Validation:

- Hanging send and read paths return within the documented bound or respond to
  cancellation.
- Timed-out downloads clean up artifacts and leave refresh state reusable.
- GeoLocation and IPFilter refresh success paths remain unchanged.

Status:

- Done 2026-05-08 in app commit `84020af`.
- Validated with workspace `validate`, Release x64 main app build, and Debug
  x64 main app build.
- `DirectDownload::DownloadUrlToFile` now applies bounded WinInet connect, send,
  and receive timeouts, plus a five-minute total background download deadline
  across repeated reads. Timeout failure returns `false` and preserves failed
  artifact cleanup.

### BUG-097 - startup-cache save worker owner lifetime

Implementation:

- Replace the startup-cache worker request's raw `CSharedFileList*` authority
  with an explicitly owned operation state or lifetime token.
- Ensure worker completion, failed UI notification, shutdown abandon, and owner
  destruction consume the operation state exactly once.
- Stop passing raw owner pointers through `UM_STARTUP_CACHE_SAVE_COMPLETE` as
  the lifetime authority.
- Make failed `PostMessage` cleanup terminal without worker-thread mutation of
  possibly destroyed owner state.
- Preserve startup-cache file format, successful save behavior, skip behavior
  after interrupted hashing, and startup performance assumptions.

Validation:

- Simulated late startup-cache save completion after shutdown abandon cannot
  dereference deleted `CSharedFileList` state.
- Failed completion post cleans up deterministically without worker-to-UI
  blocking.
- Debug and Release x64 app builds pass through supported workspace entrypoints.

Status:

- Done 2026-05-08 in app commit `bde9f16`.
- Validated with workspace `validate`, Debug x64 main app build, and Release
  x64 main app build.
- The worker now carries an owner-independent operation token and posts a
  completion payload without a raw `CSharedFileList*`; shutdown abandon detaches
  the owner from the in-flight operation, and failed delivery discards persisted
  output without touching owner state.

### BUG-074 - archive preview worker cancellation and UI handoff

Disposition:

- Wont-Fix by product decision. Archive preview is deprecated, entirely frozen,
  and its known bugs are not part of R1 hardening unless the feature is
  explicitly unfrozen.
- Source comment added near the archive preview scanner thread launch in app
  commit `8c2cc67` to make this status clear during future code review.

Status:

- Wont-Fix. See [BUG-074](../items/BUG-074.md).

### BUG-098 - archive recovery worker part-file lifetime

Disposition:

- Wont-Fix by product decision. Archive recovery is deprecated, entirely
  frozen, and its known bugs are not part of R1 hardening unless the feature is
  explicitly unfrozen.
- Source comment added near `CArchiveRecovery::recover` in app commit
  `8c2cc67` to make this status clear during future code review.

Status:

- Wont-Fix. See [BUG-098](../items/BUG-098.md).

### BUG-099 - WebSocket listener startup exception safety

Implementation:

- Add narrow RAII or structured cleanup around termination event, SSL state,
  listener thread object, and startup flags before listener startup is fully
  committed.
- Wrap listener `CWinThread` allocation and `CreateThread` startup so all
  failure paths unwind initialized state exactly once.
- Preserve existing successful HTTP/HTTPS startup and previous R1 WebSocket
  restart-safety behavior.

Validation:

- Injected allocation or thread-start failure cannot leave SSL or termination
  state half-initialized.
- Stop/start cycles still work for HTTP and HTTPS.
- Debug and Release x64 app builds pass through supported workspace entrypoints.

Status:

- Done 2026-05-08 in app commit `a4c4dc3`.
- Validated with workspace `validate`, Debug x64 main app build, and Release
  x64 main app build.
- `StartSockets` now unwinds termination-event, SSL, and listener-thread object
  state on allocation, exception, and `CreateThread` startup failure paths.

### BUG-100 - DirectDownload hard owner cancellation

Implementation:

- Keep BUG-096 bounded WinInet timeouts as the baseline fallback.
- Add an explicit owner cancellation path for background direct downloads,
  likely through options/context state that lets owner shutdown close active
  WinInet handles safely.
- Define single-owner or synchronized handle close semantics so cancellation and
  normal worker cleanup cannot double-close.
- Preserve successful download, proxy, temp-file cleanup, and BUG-091
  close-time persistence behavior.

Validation:

- A blocked send/read seam responds to owner cancellation and returns failure.
- Cancellation removes partial artifacts and leaves refresh state reusable.
- GeoLocation/IPFilter refresh success, timeout, cancellation, retry, and
  shutdown behavior remain deterministic.
- Debug and Release x64 app builds pass through supported workspace entrypoints.

Status:

- Open. See [BUG-100](../items/BUG-100.md).

## Release Exit Criteria

All covered items must be either:

- `Done` with commit evidence and targeted validation results, or
- explicitly reclassified by product decision in `RELEASE-1.0.md`.

Covered items through [BUG-097](../items/BUG-097.md) are `Done` on `main` with
commit evidence. Archive preview/recovery findings [BUG-074](../items/BUG-074.md)
and [BUG-098](../items/BUG-098.md) are Wont-Fix because those deprecated
features are frozen. The newly promoted follow-up blockers
[BUG-100](../items/BUG-100.md) remains open and must be closed or explicitly
reclassified before tagging.
