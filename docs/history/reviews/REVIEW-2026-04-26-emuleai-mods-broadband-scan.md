# Review 2026-04-26 - eMuleAI and Mod Archive Broadband Scan

## Scope

Compared the current broadband branch direction against:

- `EMULE_WORKSPACE_ROOT\analysis\emuleai`
- `EMULE_WORKSPACE_ROOT\analysis\mods-archive`
- `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main`

The goal is to keep the broadband edition close to stock eMule while staying
open to features that are practical for modern high-bandwidth, long-running
sessions.

## Current-Main Correction

`FEAT-038` is now marked `Done`.

Current `main` already contains monitored shared-root support:

- app-level shared-directory monitor startup and watcher loop
- persisted `shareddir.monitored.dat` state
- Shared Directories context-menu commands for monitored roots
- UI handoff through `UM_MONITORED_SHARED_DIR_UPDATE`
- catch-up/journal logic for monitored roots

This landed through the `FEAT-033` / `BUG-034` shared-directory line, including
commits `138f577` and `60b3b44`. It closes the watcher/live recursive sync
feature surface, but it does not close `FEAT-034`: blocking filesystem I/O
during shared hashing remains a separate manual reload / shutdown-hardening
concern.

## New Backlog Promotions

`BUG-068` records an eMuleAI v1.4 UI correctness fix that current `main` does
not appear to carry: progress-bar drawing in Downloads and Downloading Clients
should isolate flat-bar GDI state and reject invalid narrow rectangles.

`FEAT-043` records the useful slice of eMuleAI's Known Clients work: large
history/list responsiveness through incremental refresh and sort-impact-aware
updates. The broader CShield/client-history product layer remains separate.

`FEAT-044` records the IP-filter input-policy improvements that sit naturally
after `FEAT-042`: PeerGuardian `*.p2p` import, static overlays, whitelist
precedence, and optional private-IP exemption.

## Existing Backlog Reaffirmed

The scan did not create duplicate items for features that are already tracked:

- `FEAT-011` covers the CShield/protection-panel direction.
- `FEAT-018`, `FEAT-035`, and `FEAT-036` cover uTP, IPv6, and NAT traversal.
- `FEAT-019` covers dark mode.
- `FEAT-021` and `FEAT-031` cover source persistence and remote shared-file
  inventory browsing.
- `FEAT-037` covers PowerShare, Share Only The Need, Hide Overshares, and
  default share-permission policy.
- `FEAT-039` covers Download Checker.
- `FEAT-040` covers headless/web/mobile control and multi-user permissions.
- `FEAT-041` covers Download Inspector automation.
- `FEAT-042` is already done for automatic IP-filter update scheduling.

## Refreshed Bug Notes

`BUG-004` remains open. eMuleAI is useful for richer IP-filter inputs, but it
does not by itself close the different-level overlap semantics documented in
the current item.

`BUG-028` remains in progress. eMuleAI reinforces the preferred closure path:
retire the `id3lib` fallback or move to a bundled/first-class MediaInfo path
after licensing and packaging review. The current `main` mitigation only makes
MediaInfo the preferred path when the DLL is available.

## Deferred Or Non-Promoted Findings

Several mod/eMuleAI ideas remain reference-only for now:

- built-in language resources and translator tooling: high churn, not a
  broadband core differentiator
- broad toolbar/state-preview/client-note/own-credit UI expansion: useful, but
  not close-stock enough to promote without a user-visible product decision
- connection-checker rework: current eMule already has Test Ports; importing a
  second external diagnostic policy should wait for a diagnostics milestone
- AICH known2 split/write-buffer ideas from historical mods: useful evidence
  for metadata I/O batching, but currently covered by `FEAT-034`-style I/O
  hardening if it becomes necessary
- full CShield/manual-punishment UI: already scoped under `FEAT-011`, not a
  prerequisite for the narrow Known Clients performance item

## Outcome

Docs now distinguish:

- landed current-main behavior: `FEAT-038`
- new low-drift hardening/performance candidates: `BUG-068`, `FEAT-043`,
  `FEAT-044`
- broad product expansion that remains intentionally opt-in and separately
  tracked
