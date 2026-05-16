# Current Main Bug, Concurrency, And Persistence Scan

This reference note records the 2026-04-26 scan of
`EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` for bugs,
concurrency issues, memory risks, persistence crash windows, and small
legacy-code hardening opportunities.

Active status and implementation order are tracked in
[`../../active/INDEX.md`](../../active/INDEX.md). The dated historical review is
[`../reviews/REVIEW-2026-04-26-main-bug-concurrency-scan.md`](../reviews/REVIEW-2026-04-26-main-bug-concurrency-scan.md).

## Summary

The scan found six current-main issues worth tracking:

| Backlog | Area | Summary |
|---------|------|---------|
| [BUG-069](../items/BUG-069.md) | WebServer/static files | Static file requests need final canonical root-containment checks and bounded streaming. |
| [BUG-070](../items/BUG-070.md) | helper threads | Upload/disk helper shutdown waits should handle worker launch failure. |
| [BUG-071](../items/BUG-071.md) | server list persistence | `server.met` save and auto-update should use checked atomic promotion. |
| [BUG-072](../items/BUG-072.md) | Kad persistence | `preferencesKad.dat` and `nodes.dat` should stop saving in place. |
| [BUG-073](../items/BUG-073.md) | WebServer sessions | Session and bad-login arrays need synchronization across request threads. |
| [BUG-074](../items/BUG-074.md) | archive preview | The scanner needs real cancellation/lifetime synchronization or retirement. |

## Maintenance Fit

All six findings are compatible with the broadband edition's close-to-stock
direction:

- they do not alter ED2K/Kad protocol policy;
- they preserve the existing UI and WebServer behavior for valid inputs;
- they continue already-landed durability and lifetime-hardening patterns;
- they can be implemented as granular fixes with targeted regression tests.

## WebServer Notes

The current WebSocket accept loop starts an accepted-request thread per allowed
connection and dispatches to `CWebServer::_ProcessURL()` or
`CWebServer::_ProcessFileReq()`.

Two issues follow from that model:

- static-file serving should defend itself with final path canonicalization and
  root containment, even though the caller filters obvious `..` strings;
- WebServer session and bad-login arrays should be protected by a narrow lock
  because login, logout, bad-login throttling, timeout refresh, and session
  lookup can all run concurrently.

The fix should avoid holding a session lock while sending socket data or
posting/sending UI messages.

## Persistence Notes

`server.met`, `preferencesKad.dat`, and `nodes.dat` still have in-place or
destructive-promotion save paths. They should follow the same durability model
already used for part metadata, `known.met`, `cancelled.met`, and the IP filter
updater:

- write to a temporary path;
- flush/commit;
- validate where applicable;
- atomically promote while preserving the old live file on failure;
- check and log promotion failures.

For Kad, the FastKad sidecar should have an explicit ordering rule relative to
the `nodes.dat` promotion so partial saves cannot leave mismatched metadata.

## Threading Notes

The upload disk I/O thread, part-file write thread, and upload bandwidth
throttler assume worker construction succeeds. Capturing launch success and
making shutdown wait paths conditional is a small hardening step that improves
low-resource behavior without changing steady-state transfer logic.

Archive preview remains a legacy UI surface. If it is retained, its worker
handoff should stop relying on `volatile bool` plus synchronous `SendMessage()`.
If it is retired under the legacy-feature cleanup track, `BUG-074` can close as
part of that removal.
