# Current Main Bug, Concurrency, And Persistence Scan - 2026-04-26

## Scope

This pass scanned the active app worktree at
`EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` on `main`, focusing on
bugs, concurrency issues, memory risks, persistence crash windows, and small
legacy-code fixes that fit the broadband edition's close-to-stock maintenance
model.

No app source changes were made for this review.

## Findings Added

| ID | Priority | Area | Finding |
|----|----------|------|---------|
| [BUG-069](BUG-069.md) | Major | WebServer/static files | Static resource serving does not prove final path containment and reads whole files into memory. |
| [BUG-070](BUG-070.md) | Minor | helper threads/shutdown | Several helper thread constructors ignore `AfxBeginThread()` failure before shutdown waits. |
| [BUG-071](BUG-071.md) | Major | server list persistence | `server.met` save and auto-update still use destructive backup/promotion moves. |
| [BUG-072](BUG-072.md) | Minor | Kad persistence | `preferencesKad.dat` and `nodes.dat` still save directly to live files. |
| [BUG-073](BUG-073.md) | Major | WebServer/session concurrency | Session and bad-login arrays are mutated from concurrent request threads without synchronization. |
| [BUG-074](BUG-074.md) | Minor | archive preview threading | Archive preview scanner uses volatile cancellation and synchronous worker-to-UI result handoff. |

## Scan Notes

- WebServer request handling is still threaded per accepted connection. That
  makes session/bad-login state and static-file helpers current concurrency and
  security-relevant surfaces, not historical-only cleanup.
- The persistence findings deliberately extend already-landed safe-promotion
  work from part metadata, `known.met`, `cancelled.met`, and `ipfilter.dat`
  without changing product behavior.
- The helper-thread launch finding is a stress/low-resource hardening item. It
  is unlikely on normal startup, but it is cheap to make explicit and testable.
- The archive-preview finding should be handled together with the existing
  archive-recovery backlog. Retiring the feature remains a valid low-drift
  outcome if preview is not worth maintaining.

## Items Rechecked But Not Reopened

- Broad `catch (...)`, `ASSERT(0)`, unsafe formatting, deprecated Winsock, and
  volatile/threading modernization are already tracked by existing backlog or
  architecture documents.
- WebSocket and MiniUPnP forced termination remain covered by `BUG-033` and were
  not duplicated.
- Download progress-bar drawing is already tracked as `BUG-068`.

## Recommended Order

1. Fix [BUG-069](BUG-069.md) and [BUG-073](BUG-073.md) before expanding the
   WebServer/REST surface further.
2. Fix [BUG-071](BUG-071.md) and [BUG-072](BUG-072.md) as the next persistence
   durability slice, reusing the current atomic-promotion helpers where possible.
3. Fix [BUG-070](BUG-070.md) when touching upload/disk helper threads or when
   adding low-resource startup/shutdown tests.
4. Resolve [BUG-074](BUG-074.md) together with the archive-preview retain/remove
   decision behind `BUG-002`, `BUG-013`, and `REF-025`.
