# eMule Active Backlog — Issue Index

This directory is the active backlog and revalidation layer for this repo. Use
[`../INDEX.md`](../INDEX.md) for long-form background and reference reading.

> Historical reference only: `stale-v0.72a-experimental-clean` and
> `analysis\stale-v0.72a-experimental-clean` are retired reference sources, not
> active branch targets or current baselines. Use them only as provenance or
> idea-extraction sources; landed status is determined against `main`. See
> [Historical References](../HISTORICAL-REFERENCES.md).

## Current Snapshot

**Source of truth:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` (`main` branch)  
**Current non-done count:** `60`
**Latest release-doc refresh:** 2026-05-13
**Non-done by status:** `37` Open, `7` In Progress, `16` Deferred, `0` Blocked.
**Backlog counts:** item tables below are authoritative.
**Beta 0.7.3 relevance:** Most non-done items below are future or deferred work;
current beta gate and proof status is controlled by [RELEASE-0.7.3](RELEASE-0.7.3.md).
**Broadband release status:** `emule-bb-v0.7.3` is the first beta/public
release target. Superseded `1.0.0`, `1.0.1`, and `1.1.1` labels are internal
evidence only and must not be published.
**Beta-release backlog view:** [RELEASE-0.7.3](RELEASE-0.7.3.md)
**Beta-release checklist:** [RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md)
**Beta-release runbook:** [RELEASE-0.7.3-RUNBOOK](RELEASE-0.7.3-RUNBOOK.md)
**Beta controller surface matrix:** [CONTROLLER-SURFACE-MATRIX](CONTROLLER-SURFACE-MATRIX.md)
**Beta-release execution plan:** [RELEASE-0.7.3-EXECUTION-PLAN](plans/RELEASE-0.7.3-EXECUTION-PLAN.md)
**Historical beta evidence:** [release-0.7.3](../history/release-0.7.3/)
**Historical reviews:** [reviews](../history/reviews/)
**Closed item records:** [items](../history/items/)

Current release trail:

- [RELEASE-0.7.3](RELEASE-0.7.3.md)
- [RELEASE-0.7.3-CHECKLIST](RELEASE-0.7.3-CHECKLIST.md)
- [RELEASE-0.7.3-RUNBOOK](RELEASE-0.7.3-RUNBOOK.md)
- [CONTROLLER-SURFACE-MATRIX](CONTROLLER-SURFACE-MATRIX.md)
- [RELEASE-0.7.3 execution plan](plans/RELEASE-0.7.3-EXECUTION-PLAN.md)

## Operating Rules

**Priority scale:** Critical > Major > Minor > Trivial  
**Status values:** Open / In Progress / Blocked / Deferred / Passed / Done /
Wont-Fix

**Directory role:** `docs/active/` owns current backlog status, release
control, active item evidence, and the current release execution plan. Closed
item records and dated review provenance live under `docs/history/`.

**Important:** Items marked Open, In Progress, Blocked, or Deferred link to
active item records. Items marked Done, Passed, or Wont-Fix link to archived
item records under `docs/history/items/`. In Progress work may already be
implemented on dedicated bug/feature branches but is not considered landed
until merged to `main`. Experimental-only work (see individual docs) is not in
`main` unless the item status below says otherwise.

**Revalidation rule:** Before implementing any item, re-check it against current `main`
and current dependency pins.

**Regression rule:** New feature/fix work from this backlog should include targeted
regression checks. When behavior changes, compare `main` against
`release/v0.72a-community` as the seam-enabled parity and regression baseline
where that comparison is meaningful.

**Beta 0.7.3 source rule:** the public beta tag is cut from the selected
reviewed `main` commit after refreshed proof passes and operator approval.
`release/v0.72a-broadband` is a stabilization/reference branch for this beta,
not the tag source.

**Baseline stack rule:**

- `release/v0.72a-community` = seam-enabled parity and regression baseline,
  test-only
- `tracing-harness/v0.72a-community` = behavior-changing variant-client parity
  harness, not the default baseline
- `release/v0.72a-broadband` = broadband pre-release stabilization/reference
  branch

---

## Bugs

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [BUG-001](../history/items/BUG-001.md) | Major | Done | 17+ load-only hidden prefs not written back to preferences.ini |
| [BUG-002](../history/items/BUG-002.md) | Minor | Wont-Fix | ASSERT(0) FIXME in ArchiveRecovery.cpp — silent fail in release *(kept as-is by product decision)* |
| [BUG-003](../history/items/BUG-003.md) | Minor | Done | Historical large-file FIXME markers overstated the remaining live issue |
| [BUG-004](../history/items/BUG-004.md) | Minor | Done | IPFilter overlapping IP ranges not handled — acknowledged correctness gap |
| [BUG-005](../history/items/BUG-005.md) | Minor | Wont-Fix | Kad buddy connections broken when RequireCrypt is enabled |
| [BUG-006](../history/items/BUG-006.md) | Minor | Wont-Fix | Weak RNG for crypto challenge — rand() seeded with time(NULL) *(accepted risk by product decision)* |
| [BUG-007](../history/items/BUG-007.md) | Minor | Done | Ring.h — three UB + correctness bugs in CRing\<T\> (CODEREV_003, 004, 011) |
| [BUG-008](../history/items/BUG-008.md) | Minor | Wont-Fix | CaptchaGenerator — rand() & 8 bimodal jitter *(low release value; leave to REF-027 if reopened)* |
| [BUG-009](../history/items/BUG-009.md) | Minor | Done | PartFile — non-atomic part.met replacement (_tremove + _trename crash window) |
| [BUG-010](../history/items/BUG-010.md) | Minor | Done | PartFile — part.met write on low disk space risks truncation/corruption |
| [BUG-011](../history/items/BUG-011.md) | Minor | Done | Race — shareddir_list iterated without lock in SendSharedDirectories |
| [BUG-012](items/BUG-012.md) | Minor | In Progress | CPartFile destructor calls FlushBuffer after write thread has already exited |
| [BUG-013](../history/items/BUG-013.md) | Minor | Wont-Fix | ArchiveRecovery.cpp — three unchecked malloc() calls crash on OOM *(kept as-is by product decision)* |
| [BUG-014](../history/items/BUG-014.md) | Minor | Done | ZIPFile.cpp — WriteFile return value silently discarded on two paths |
| [BUG-015](../history/items/BUG-015.md) | Minor | Done | GetTickCount() 49-day overflow in ban expiry and download timeout checks |
| [BUG-016](../history/items/BUG-016.md) | Minor | Done | UDP obfuscation applied when crypt layer is disabled — IsCryptLayerEnabled() guard missing |
| [BUG-017](../history/items/BUG-017.md) | Minor | Done | UDP throttler deadlock — sendLocker held when signaling QueueForSendingControlPacket |
| [BUG-018](../history/items/BUG-018.md) | Minor | Done | Part-file hash layout drift — hash tree can mutate during concurrent hashing |
| [BUG-019](../history/items/BUG-019.md) | Minor | Done | AICH sync thread concurrency — UI deadlocks, starvation, incomplete/duplicate nodes |
| [BUG-020](../history/items/BUG-020.md) | Minor | Done | Client socket teardown ordering — cross-link not cleared before Safe_Delete |
| [BUG-021](../history/items/BUG-021.md) | Minor | Done | Upload queue lock inversion + socket I/O result mishandling + inflate buffer aliasing |
| [BUG-022](../history/items/BUG-022.md) | Major | Done | Long-path delete-to-recycle-bin still breaks in ShellDeleteFile |
| [BUG-023](../history/items/BUG-023.md) | Minor | Done | Shared-file ED2K published column shows a false `No` after publish-state reset |
| [BUG-024](../history/items/BUG-024.md) | Minor | Done | `statUTC(HANDLE)` returns corrupted `st_size` by using `nFileIndexLow` |
| [BUG-025](../history/items/BUG-025.md) | Minor | Done | KnownFile hashing open failures log stale or wrong error text on Win32 open failure |
| [BUG-026](../history/items/BUG-026.md) | Major | Done | Search tab teardown frees live result/tab payload objects before the UI detaches them |
| [BUG-027](../history/items/BUG-027.md) | Major | Done | IP filter update can delete the live `ipfilter.dat` before replacement promotion succeeds |
| [BUG-028](../history/items/BUG-028.md) | Minor | Wont-Fix | MP3 ID3 metadata extraction is ANSI-only; non-ACP filenames can silently lose tags |
| [BUG-029](../history/items/BUG-029.md) | Major | Done | Long-path tail hardening across config, media, shell, and GeoLocation surfaces |
| [BUG-030](../history/items/BUG-030.md) | Minor | Done | Obfuscated server logins can advertise redundant callback crypto flags and require extra attempts |
| [BUG-031](items/BUG-031.md) | Minor | Deferred | Shared-file hashing fails too eagerly on transient sharing and lock violations |
| [BUG-032](../history/items/BUG-032.md) | Minor | Done | AICH hashset save can fail spuriously after hashing because `known2.met` lock wait times out |
| [BUG-033](../history/items/BUG-033.md) | Minor | Wont-Fix | WebSocket and MiniUPnP shutdown still use forced thread termination |
| [BUG-034](items/BUG-034.md) | Minor | In Progress | Release paths silently swallow unexpected exceptions via catch (...) plus ASSERT(0) |
| [BUG-035](items/BUG-035.md) | Minor | In Progress | Historical control-flow still uses bare ASSERT(0) without recovery or logging |
| [BUG-036](../history/items/BUG-036.md) | Major | Done | `known.met` and `cancelled.met` still save in place and can truncate on failure |
| [BUG-037](../history/items/BUG-037.md) | Major | Done | Same-hash KnownFile replacement can unshare or mis-track equivalent files |
| [BUG-038](../history/items/BUG-038.md) | Minor | Done | Shared Files sort can retain stale rows after backing data changes |
| [BUG-039](../history/items/BUG-039.md) | Minor | Done | Client list lacked a reusable safe pointer membership check |
| [BUG-040](../history/items/BUG-040.md) | Major | Done | Downloading Clients list could dereference stale client rows |
| [BUG-041](../history/items/BUG-041.md) | Major | Done | Known Clients list could dereference stale client rows |
| [BUG-042](../history/items/BUG-042.md) | Major | Done | Upload list could dereference stale upload rows |
| [BUG-043](../history/items/BUG-043.md) | Major | Done | Queue list could dereference stale queue rows |
| [BUG-044](../history/items/BUG-044.md) | Major | Done | Download source rows could outlive their backing source objects |
| [BUG-045](../history/items/BUG-045.md) | Minor | Done | Server list could dereference stale server rows |
| [BUG-046](../history/items/BUG-046.md) | Major | Done | Kad contact list could dereference stale contact rows |
| [BUG-047](../history/items/BUG-047.md) | Major | Done | Kad search list could dereference stale search rows |
| [BUG-048](../history/items/BUG-048.md) | Minor | Done | IRC nick rows were not cleared before nick objects were deleted |
| [BUG-049](../history/items/BUG-049.md) | Minor | Done | IRC channel tabs were not detached before channel objects were deleted |
| [BUG-050](../history/items/BUG-050.md) | Minor | Done | Chat tabs were not detached before chat items were deleted |
| [BUG-051](../history/items/BUG-051.md) | Minor | Done | IRC channel rows were not cleared before channel entries were deleted |
| [BUG-052](../history/items/BUG-052.md) | Minor | Done | Kad search constructor accidentally added placeholder rows |
| [BUG-053](../history/items/BUG-053.md) | Major | Done | part.met backup could be refreshed from the newly written metadata |
| [BUG-054](../history/items/BUG-054.md) | Major | Done | ESC in shared-file delete confirmation could still delete files |
| [BUG-055](../history/items/BUG-055.md) | Major | Done | AICH recovery accepted invalid part bounds |
| [BUG-056](../history/items/BUG-056.md) | Major | Done | Download Clients list could dereference stale rows during display callbacks |
| [BUG-057](../history/items/BUG-057.md) | Minor | Done | Close All Search Results could leave Kad keyword searches running |
| [BUG-058](../history/items/BUG-058.md) | Minor | Done | Tree option value labels could contain the parser separator |
| [BUG-059](../history/items/BUG-059.md) | Trivial | Done | Download Remaining column alignment was inconsistent |
| [BUG-060](../history/items/BUG-060.md) | Major | Done | REST API should stay available when web templates are absent |
| [BUG-061](../history/items/BUG-061.md) | Major | Done | Legacy web interface template was missing from the shipped tree |
| [BUG-062](../history/items/BUG-062.md) | Minor | Done | Obfuscated server timeout did not retry plain connection promptly |
| [BUG-063](../history/items/BUG-063.md) | Major | Done | ESC in shared-directory delete confirmation could still delete directories |
| [BUG-064](../history/items/BUG-064.md) | Minor | Done | Client list secondary display path needed stale-row guarding |
| [BUG-065](../history/items/BUG-065.md) | Minor | Done | Queue list secondary display path needed stale-row guarding |
| [BUG-066](../history/items/BUG-066.md) | Minor | Done | Upload list secondary display path needed stale-row guarding |
| [BUG-067](../history/items/BUG-067.md) | Minor | Done | REST log route lacked the expected get alias seam |
| [BUG-068](../history/items/BUG-068.md) | Minor | Done | Download progress-bar drawing can leak GDI state into neighboring list cells |
| [BUG-069](../history/items/BUG-069.md) | Major | Done | WebServer static resource requests can escape the web root and allocate whole files |
| [BUG-070](../history/items/BUG-070.md) | Minor | Done | Ignored helper-thread launch failures can hang shutdown waits |
| [BUG-071](../history/items/BUG-071.md) | Major | Done | server.met persistence still uses destructive backup and promotion moves |
| [BUG-072](../history/items/BUG-072.md) | Minor | Done | Kad preferences and routing snapshots still save in place |
| [BUG-073](../history/items/BUG-073.md) | Major | Done | WebServer session and bad-login state is mutated from request threads without synchronization |
| [BUG-074](../history/items/BUG-074.md) | Minor | Wont-Fix | Archive preview scanner uses volatile cancellation and synchronous UI handoff *(deprecated/frozen)* |
| [BUG-075](../history/items/BUG-075.md) | Major | Passed | REST and WebServer typed error consistency |
| [BUG-076](../history/items/BUG-076.md) | Major | Passed | WebServer malformed request hardening for REST and legacy HTML |
| [BUG-077](../history/items/BUG-077.md) | Minor | Passed | WebServer concurrent REST and legacy HTML soak coverage |
| [BUG-078](../history/items/BUG-078.md) | Critical | Done | qBit compatibility auth can fail open when session RNG is unavailable |
| [BUG-079](../history/items/BUG-079.md) | Critical | Done | WebSocket shutdown can close the termination event while accepted clients still wait on it |
| [BUG-080](../history/items/BUG-080.md) | Major | Done | WebSocket shutdown can forcibly terminate the listener thread |
| [BUG-081](../history/items/BUG-081.md) | Major | Done | HTTPS WebSocket handshake and read loops can spin on WANT_READ/WANT_WRITE |
| [BUG-082](../history/items/BUG-082.md) | Major | Done | GeoLocation and IPFilter background refresh flags can race and remain stuck |
| [BUG-083](../history/items/BUG-083.md) | Major | Done | Client UDP malformed-packet logging can read past a one-byte packet |
| [BUG-084](../history/items/BUG-084.md) | Minor | Done | Web admin high-level actions leak the process token handle |
| [BUG-085](../history/items/BUG-085.md) | Major | Done | Kad/client UDP encryption preference gating needs Release 1 compatibility proof |
| [BUG-086](../history/items/BUG-086.md) | Critical | Done | HTTPS WebSocket casts SOCKET storage to mbedtls_net_context |
| [BUG-087](../history/items/BUG-087.md) | Critical | Done | HTTPS WebSocket queued writes can stall after TLS WANT_READ |
| [BUG-088](../history/items/BUG-088.md) | Major | Done | WebSocket timeout shutdown leaves global state unsafe for restart |
| [BUG-089](../history/items/BUG-089.md) | Major | Done | UDP control sender can deadlock on exception while holding sendLocker |
| [BUG-090](../history/items/BUG-090.md) | Major | Done | Background refresh completion can wedge when UI PostMessage fails |
| [BUG-091](../history/items/BUG-091.md) | Major | Done | DirectDownload ignores close-time write failures |
| [BUG-092](../history/items/BUG-092.md) | Critical | Done | Background refresh workers can write through freed owner memory after shutdown |
| [BUG-093](../history/items/BUG-093.md) | Critical | Done | Failed refresh completion can synchronously block worker on UI thread |
| [BUG-094](../history/items/BUG-094.md) | Major | Done | ResumeThread failure leaks suspended refresh thread objects |
| [BUG-095](../history/items/BUG-095.md) | Major | Done | WebSocket accepted-client tracking is not exception-safe after thread start |
| [BUG-096](../history/items/BUG-096.md) | Major | Done | DirectDownload lacks bounded timeout and cancellation contract |
| [BUG-097](../history/items/BUG-097.md) | Critical | Done | Startup-cache save worker can outlive shared-file list owner |
| [BUG-098](../history/items/BUG-098.md) | Minor | Wont-Fix | Archive recovery worker uses raw part-file owner across async work *(deprecated/frozen)* |
| [BUG-099](../history/items/BUG-099.md) | Major | Done | WebSocket listener startup is not exception-safe after global state initialization |
| [BUG-100](../history/items/BUG-100.md) | Major | Done | DirectDownload has bounded timeouts but no hard owner cancellation contract |
| [BUG-101](../history/items/BUG-101.md) | Major | Done | Shared Files 50k recursive tree stress profile does not reach main window |
| [BUG-102](../history/items/BUG-102.md) | Major | Done | aMuTorrent browser smoke ignores generated harness port |
| [BUG-111](../history/items/BUG-111.md) | Critical | Done | Release and help URLs still point outside the emulebb namespace |
| [BUG-112](../history/items/BUG-112.md) | Critical | Wont-Fix | WebServer/qBit session tokens need CSPRNG-backed generation |

`BUG-103` through `BUG-110` were superseded internal post-tag evidence labels,
not active item docs.

---

## Refactors

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-001](../history/items/REF-001.md) | Major | Wont-Fix | Keep the existing CZIPFile implementation |
| [REF-002](../history/items/REF-002.md) | Major | Done | Remove Source Exchange v1 branches |
| [REF-003](items/REF-003.md) | Trivial | Open | Rename stale IRC string resources *(or full IRC removal — see REF-025)* |
| [REF-004](../history/items/REF-004.md) | Minor | Done | Audit and disposition 17 load-only preference keys |
| [REF-005](../history/items/REF-005.md) | Trivial | Done | Remove dead DebugSourceExchange commented-out calls |
| [REF-006](../history/items/REF-006.md) | Trivial | Done | GetCategory should be const in DownloadListCtrl |
| [REF-007](../history/items/REF-007.md) | Trivial | Done | WebM vs MKV disambiguation in MIME detection |
| [REF-015](../history/items/REF-015.md) | Minor | Wont-Fix | Keep miniupnpc as the active UPnP backend |
| [REF-016](../history/items/REF-016.md) | Trivial | Wont-Fix | Keep ResizableLib out-of-tree instead of inlining it |
| [REF-017](../history/items/REF-017.md) | Minor | Done | Revalidate and close the dead-code sweep backlog item |
| [REF-018](../history/items/REF-018.md) | Minor | Done | Remove defunct PeerCache surface and legacy INI fallback reads |
| [REF-019](../history/items/REF-019.md) | Minor | Done | Replace ASSERT(0) + "must be a bug" with OnError() in EncryptedStreamSocket |
| [REF-020](../history/items/REF-020.md) | Minor | Done | Replace dynamic loading of always-present Win10 APIs with static linking |
| [REF-021](items/REF-021.md) | Minor | Deferred | Remove blanket warning suppressions and replace deprecated Winsock APIs |
| [REF-022](items/REF-022.md) | Trivial | Open | Replace custom type aliases in types.h with \<cstdint\> standard types |
| [REF-023](../history/items/REF-023.md) | Minor | Done | Replace unsafe sprintf/_stprintf/wsprintf with safe equivalents |
| [REF-024](items/REF-024.md) | Trivial | Open | Convert #define constants in Opcodes.h to constexpr in namespace |
| [REF-025](items/REF-025.md) | Minor | In Progress | Remove legacy feature set — IRC, SMTP, Scheduler, MiniMule, wizard, splash, update checker |
| [REF-026](../history/items/REF-026.md) | Minor | Done | Manifest — keep Win10/11+ compatibility GUID only and move Common Controls into manifests |
| [REF-027](items/REF-027.md) | Minor | Open | CaptchaGenerator — replace CxImage with ATL CImage / native GDI (community ref) |
| [REF-028](items/REF-028.md) | Minor | Deferred | Audit current MbedTLS 4.1 integration |
| [REF-029](items/REF-029.md) | Major | Open | Move UDP sockets to WSAPoll backend — AsyncDatagramSocket (experimental ref) |
| [REF-030](items/REF-030.md) | Minor | Open | Replace WSAAsyncGetHostByName with worker-thread resolver in DownloadQueue (experimental ref) |
| [REF-031](../history/items/REF-031.md) | Minor | Done | Review upload queue scoring against community and stale baselines |
| [REF-032](items/REF-032.md) | Minor | In Progress | Use MFC-native property sheets and dynamic layout instead of CTreePropSheet / ResizableLib |
| [REF-033](items/REF-033.md) | Trivial | Open | Remove remaining IE/MSHTML drag-drop, HTML Help, and legacy IE web-client baggage |
| [REF-034](items/REF-034.md) | Minor | Deferred | Resolve Crypto++ 8.4 vs 8.9 dependency truth |
| [REF-035](items/REF-035.md) | Minor | Open | Adopt WIL for narrow Windows and COM RAII cleanup |
| [REF-036](items/REF-036.md) | Minor | Open | Adopt GSL contracts for buffer and pointer boundary hardening |
| [REF-037](../history/items/REF-037.md) | Major | Done | Beta 0.7.3 legacy and frozen feature disposition ledger |
| [REF-038](../history/items/REF-038.md) | Minor | Done | Harden optional MediaInfo DLL loading and metadata extraction seams |
| [REF-039](../history/items/REF-039.md) | Minor | Done | Classify MediaInfo loader failures and bound metadata extraction counts |

---

## Boost Adoption Ideas (exploratory only — not planned)

> These items are exploratory idea material from
> [IDEA-BOOST](../ideas/IDEA-BOOST.md). There is no active plan to adopt Boost
> for Release 1 or current mainline work. Promote only a narrow future slice if
> explicitly approved.

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [REF-008](items/REF-008.md) | Major | Deferred | Explore CAsyncSocketEx replacement options |
| [REF-009](items/REF-009.md) | Major | Deferred | Explore thread/synchronization replacement options |
| [REF-010](items/REF-010.md) | Major | Deferred | Explore raw ownership cleanup options |
| [REF-011](items/REF-011.md) | Minor | Deferred | Explore timer replacement options |
| [REF-012](items/REF-012.md) | Minor | Deferred | Explore file/path replacement options |
| [REF-013](items/REF-013.md) | Minor | Deferred | Explore string/formatting replacement options |
| [REF-014](items/REF-014.md) | Minor | Deferred | Explore circular-buffer replacement options |

---

## Features

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [FEAT-001](items/FEAT-001.md) | Minor | Deferred | Kad FastKad — diversity-aware bootstrap ranking + aggressive stale decay |
| [FEAT-002](items/FEAT-002.md) | Major | Open | Kad SafeKad — layered trust model / CGNAT fix |
| [FEAT-003](items/FEAT-003.md) | Minor | Open | Kad — Response usefulness scoring + subnet-diversity search fanout |
| [FEAT-004](items/FEAT-004.md) | Minor | Open | Kad — Generalise KadPublishGuard abuse budget beyond PUBLISH_SOURCE |
| [FEAT-005](items/FEAT-005.md) | Minor | Open | Kad — Restore network-change grace handling |
| [FEAT-006](items/FEAT-006.md) | Minor | Open | Kad — Add observability counters (trust, budget, bootstrap) |
| [FEAT-007](items/FEAT-007.md) | Minor | Open | Windows Property Store integration for non-media file metadata |
| [FEAT-008](items/FEAT-008.md) | Trivial | Open | Oracle protocol guard seams — integrate stale branch test scaffolding |
| [FEAT-009](items/FEAT-009.md) | Trivial | Open | Mirror audit guard seam — WIP from stale branch parent |
| [FEAT-010](../history/items/FEAT-010.md) | Minor | Done | Long path support phase 2 — shell/UI, shared-directory recursion, exact-name paths, and path-helper audit |
| [FEAT-011](items/FEAT-011.md) | Minor | Open | CShield — integrate ED2K anti-leecher engine (44 bad-client categories) |
| [FEAT-012](../history/items/FEAT-012.md) | Minor | Done | PR_TCPERRORFLOODER — TCP listen-socket flood defense |
| [FEAT-013](../history/items/FEAT-013.md) | Major | Done | REST API — add authenticated in-process JSON endpoints to WebServer |
| [FEAT-014](items/FEAT-014.md) | Minor | Open | REST API follow-up — OpenAPI docs and optional external gateway |
| [FEAT-015](../history/items/FEAT-015.md) | Major | Done | Broadband upload slot controller — budget-based cap + slow-slot reclamation |
| [FEAT-016](../history/items/FEAT-016.md) | Major | Done | Modern limits — update stale hard-coded defaults for broadband/modern hardware |
| [FEAT-017](items/FEAT-017.md) | Major | Open | DPI awareness — Per-Monitor V2 manifest + hardcoded pixel audit |
| [FEAT-018](items/FEAT-018.md) | Minor | Open | µTP transport layer — CUtpSocket / libutp (eMuleAI ref) |
| [FEAT-019](items/FEAT-019.md) | Minor | Open | Dark mode UI — system-aware Windows 10 dark theme (eMuleAI ref) |
| [FEAT-020](../history/items/FEAT-020.md) | Trivial | Done | DB-IP city geolocation — location label and flag per peer |
| [FEAT-021](items/FEAT-021.md) | Minor | Open | SourceSaver — persist download source lists between sessions (eMuleAI ref) |
| [FEAT-022](../history/items/FEAT-022.md) | Minor | Done | Startup config directory override — `-c` flag for alternate preferences path |
| [FEAT-023](../history/items/FEAT-023.md) | Minor | Done | Broadband queue scoring and ratio/cooldown UI extras |
| [FEAT-024](../history/items/FEAT-024.md) | Minor | Done | Share-ignore policy with additive `shareignore.dat` |
| [FEAT-025](../history/items/FEAT-025.md) | Minor | Done | Normalize download filenames on intake and completion |
| [FEAT-026](../history/items/FEAT-026.md) | Minor | Done | Shared startup cache with known.met lookup index and `sharedcache.dat` |
| [FEAT-027](../history/items/FEAT-027.md) | Minor | Done | Startup sequencing fix, startup profiling, and shared-view startup churn cleanup |
| [FEAT-028](../history/items/FEAT-028.md) | Minor | Done | Virtualize and harden shared files list |
| [FEAT-029](../history/items/FEAT-029.md) | Minor | Done | Search result ceilings — configurable ed2k expansion plus moderate Kad totals/lifetimes |
| [FEAT-030](../history/items/FEAT-030.md) | Minor | Done | Bind policy completion — global `BindAddr` everywhere else, separate `WebBindAddr` for WebServer |
| [FEAT-031](items/FEAT-031.md) | Minor | Open | Auto-browse compatible remote shared-file inventories with persisted cache |
| [FEAT-032](items/FEAT-032.md) | Minor | Deferred | NAT mapping modernization — keep MiniUPnP, drop WinServ, add PCP/NAT-PMP |
| [FEAT-033](../history/items/FEAT-033.md) | Minor | Done | Disk-space floor hardening and legacy import-flow retirement |
| [FEAT-034](items/FEAT-034.md) | Minor | In Progress | Shared-files reload should stop blocking the UI on large trees |
| [FEAT-035](items/FEAT-035.md) | Major | Open | IPv6 dual-stack networking for peers, friends, Kad, and server surfaces |
| [FEAT-036](items/FEAT-036.md) | Major | Open | NAT traversal and extended source exchange for LowID-to-LowID connectivity |
| [FEAT-037](items/FEAT-037.md) | Minor | Deferred | Release-oriented sharing controls — PowerShare, Release Bonus, and Share Only The Need |
| [FEAT-038](../history/items/FEAT-038.md) | Minor | Done | Shared-files watcher and live recursive share sync |
| [FEAT-039](items/FEAT-039.md) | Minor | Open | Download checker — duplicate and near-duplicate intake guard |
| [FEAT-040](items/FEAT-040.md) | Major | Open | Headless core with modern web/mobile controller and multi-user permissions |
| [FEAT-041](items/FEAT-041.md) | Minor | Open | Download Inspector automation for stale downloads and majority-name rename |
| [FEAT-042](../history/items/FEAT-042.md) | Minor | Done | Automatic IP filter update scheduling |
| [FEAT-043](items/FEAT-043.md) | Minor | Open | Known Clients history and incremental list refresh performance |
| [FEAT-044](items/FEAT-044.md) | Minor | Open | IP filter input policy - PeerGuardian lists, whitelist, and private-IP exemption |
| [FEAT-045](../history/items/FEAT-045.md) | Major | Passed | REST transfer detail endpoint for controller parity |
| [FEAT-046](../history/items/FEAT-046.md) | Major | Passed | REST server and Kad bootstrap/import APIs |
| [FEAT-047](../history/items/FEAT-047.md) | Minor | Passed | REST search API completeness pass |
| [FEAT-048](../history/items/FEAT-048.md) | Minor | Passed | REST upload queue control completeness |
| [FEAT-049](../history/items/FEAT-049.md) | Minor | Passed | Curated REST preference expansion |
| [FEAT-050](../history/items/FEAT-050.md) | Minor | Passed | Launch external program on completed download |
| [FEAT-051](../history/items/FEAT-051.md) | Minor | Done | Pro-user context menus and always-on advanced controls |
| [FEAT-052](../history/items/FEAT-052.md) | Minor | Done | Main-shell keyboard shortcuts and mnemonic audit |
| [FEAT-053](../history/items/FEAT-053.md) | Minor | Done | Classic tray balloon notification mode |
| [FEAT-054](../history/items/FEAT-054.md) | Minor | Done | Normalize download message filename display |
| [FEAT-055](../history/items/FEAT-055.md) | Minor | Done | Beta 0.7.3 improvement triage lane |
| [FEAT-056](items/FEAT-056.md) | Minor | Deferred | Post-beta-0.7.3 release proof automation and operator evidence UX |

---

## Build / CI / Tooling

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [CI-001](items/CI-001.md) | Major | Deferred | CMake adoption exploration — replace emule.vcxproj with CMakeLists.txt + Ninja |
| [CI-002](items/CI-002.md) | Minor | Open | clang-format — enforce consistent code formatting |
| [CI-003](../history/items/CI-003.md) | Minor | Done | MSVC compiler hardening — SDL, guard:cf, /WX (Phase A done: SDL+CFG in commit `5557216`) |
| [CI-004](items/CI-004.md) | Minor | Open | clang-tidy — integrate static analysis |
| [CI-005](items/CI-005.md) | Minor | Open | cppcheck — integrate complementary bug-class analysis |
| [CI-006](items/CI-006.md) | Minor | Open | MSVC AddressSanitizer — enable for debug builds |
| [CI-007](items/CI-007.md) | Minor | Open | Kad — Expand integration and fuzz test coverage |
| [CI-008](../history/items/CI-008.md) | Minor | Done | Expand regression coverage for part files, long paths, and WebServer/REST |
| [CI-009](../history/items/CI-009.md) | Minor | Done | Share-ignore regression coverage and Release test-build stabilization |
| [CI-010](items/CI-010.md) | Minor | In Progress | Reduce remaining app-local warning debt after external noise cleanup |
| [CI-011](../history/items/CI-011.md) | Major | Done | Broadband release live E2E coverage umbrella |
| [CI-012](../history/items/CI-012.md) | Major | Done | Stabilize Shared Files dynamic folder lifecycle E2E |
| [CI-013](../history/items/CI-013.md) | Major | Done | Download and search UI live scenarios |
| [CI-014](../history/items/CI-014.md) | Major | Passed | REST contract manifest and live completeness gate |
| [CI-015](../history/items/CI-015.md) | Major | Passed | REST malformed and concurrent request matrix |
| [CI-016](../history/items/CI-016.md) | Minor | Passed | REST-only main vs community regression lane |
| [CI-017](../history/items/CI-017.md) | Minor | Done | Normalize active workspace line-ending policy to LF by default |
| [CI-018](../history/items/CI-018.md) | Major | Done | Shared Files 50k-file tree refresh stress gate |
| [CI-019](../history/items/CI-019.md) | Major | Done | HTTPS and REST socket adversity stress gate |
| [CI-020](../history/items/CI-020.md) | Major | Done | REST and legacy WebServer error-path coverage gate |
| [CI-021](../history/items/CI-021.md) | Major | Done | WebSocket and legacy socket leak-churn gate |
| [CI-022](../history/items/CI-022.md) | Major | Done | Beta 0.7.3 community parity changed-surface ledger |
| [CI-023](../history/items/CI-023.md) | Major | Done | Beta 0.7.3 post-1.0 hardening regression replay gate |
| [CI-024](../history/items/CI-024.md) | Major | Done | Beta 0.7.3 controller integration full replay gate |
| [CI-025](../history/items/CI-025.md) | Major | Done | Beta 0.7.3 REST and adapter contract drift gate |
| [CI-026](../history/items/CI-026.md) | Major | Done | Beta 0.7.3 shared files, startup cache, and long-path parity gate |
| [CI-027](../history/items/CI-027.md) | Major | Done | Beta 0.7.3 download and persistence replay gate |
| [CI-028](../history/items/CI-028.md) | Major | Done | Beta 0.7.3 search, server, and Kad parity replay gate |
| [CI-029](../history/items/CI-029.md) | Major | Done | Beta 0.7.3 network socket, UDP, WebSocket, HTTPS, and UPnP adversity gate |
| [CI-030](../history/items/CI-030.md) | Major | Done | Beta 0.7.3 UI, preferences, tray, and language resource parity smoke gate |
| [CI-031](../history/items/CI-031.md) | Major | Done | Beta 0.7.3 packaging, architecture, and release asset parity gate |
| [CI-032](../history/items/CI-032.md) | Major | Done | Beta 0.7.3 post-tag focused coverage gaps |
| [CI-033](../history/items/CI-033.md) | Major | Done | Beta 0.7.3 internal pre-release proof |
| [CI-034](../history/items/CI-034.md) | Major | Done | Package-release provenance and dirty-input guard |
| [CI-035](items/CI-035.md) | Major | Open | Final current-head beta proof and fresh package hashes |

---

## Controller Integrations

| ID | Priority | Status | Title |
|----|----------|--------|-------|
| [AMUT-001](../history/items/AMUT-001.md) | Major | Passed | aMuTorrent eMule BB browser smoke coverage |
| [AMUT-002](../history/items/AMUT-002.md) | Major | Passed | aMuTorrent transfer detail hydration |
| [ARR-001](../history/items/ARR-001.md) | Major | Passed | Full Arr release E2E validation |

---

## Release Focus

Beta 0.7.3 hardening is controlled by [RELEASE-0.7.3](RELEASE-0.7.3.md).
Use that page for release status, source decision, and the open beta task table.
The current implementation sequence lives in the single
[Beta 0.7.3 execution plan](plans/RELEASE-0.7.3-EXECUTION-PLAN.md).
Superseded release gate evidence and old cluster plans live under
`docs\history\release-0.7.3`.

## Reference Material

- [Backlog history](../history/BACKLOG-HISTORY.md)
- [Backlog dependency graph](../history/BACKLOG-DEPENDENCY-GRAPH.md)
- [Backlog source salvage](../history/BACKLOG-SOURCE-SALVAGE.md)

Current issue status is tracked here. Other `docs/` areas contain reference,
history, architecture notes, audits, ideas, and active execution plans according
to [DOCS_POLICY](../DOCS_POLICY.md).
