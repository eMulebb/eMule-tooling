# Release 1.0 SDET Stress Execution Plan

This plan owns the R1 test-robustness gaps from the 2026-05-08 SDET stability
review. These are release-gate test items, not product feature work. They block
`emule-bb-v1.0.0` until implemented, run, and reflected in their item docs.

Covered items:

- [CI-018](../items/CI-018.md) - Shared Files 10k-node tree refresh stress gate
- [CI-019](../items/CI-019.md) - HTTPS and REST socket adversity stress gate
- [CI-020](../items/CI-020.md) - REST and legacy WebServer error-path coverage gate
- [CI-021](../items/CI-021.md) - WebSocket and legacy socket leak-churn gate

## Current State

The existing R1 suite has strong native REST parser/status tests and live HTTP
REST stress evidence. The uncovered R1 risk is at the hostile live boundary:
large Shared Files UI churn, HTTPS handshake stalls, socket resets, live 500
fault paths, and resource-accounted socket churn.

## Sequencing

1. Implement [CI-018](../items/CI-018.md) first because it expands the Shared
   Files fixture and UI-harness capabilities that later release runs can reuse.
2. Implement [CI-019](../items/CI-019.md) next to put the existing REST contract
   and stress matrix through HTTPS and raw socket adversity.
3. Implement [CI-020](../items/CI-020.md) after the HTTPS harness path exists so
   the error-path matrix can run over both HTTP and HTTPS where useful.
4. Implement [CI-021](../items/CI-021.md) last as the resource-accounting soak
   that combines the socket churn surfaces and proves cleanup.

Each slice must be committed and pushed before the next independent slice
starts.

## Shared Rules

- Use supported workspace entrypoints for build, validation, and live E2E.
- Keep new stress modes selectable so routine R1 gates can run a bounded smoke
  profile and operators can run longer soak profiles.
- Preserve legacy ED2K/Kad runtime behavior; these items add proof and harness
  coverage, not protocol changes.
- Emit durable artifacts for every gate: command line, profile settings,
  request counts, status counts, timeout counts, resource deltas, and sampled
  failures.
- Treat public-network absence as inconclusive only when the harness records
  enough diagnostics to distinguish environment failure from product failure.

## Detailed Plan

### CI-018 - Shared Files 10k-node tree refresh stress gate

Implementation:

- Add a 10k+ node fixture profile to the Shared Files fixture generator.
- Add tree collapse support and a rapid churn driver to the Shared Files UI
  live harness.
- Combine expand/collapse/select/reload/sort/paint operations with monitored
  filesystem mutations under shared roots.
- Cross-check UI-visible state with REST shared-file and shared-directory
  snapshots after each churn phase.
- Capture screenshots, REST snapshots, selected path, row counts, timeout
  reasons, and process resource deltas on failure.

Validation:

- Run the smoke budget through the supported `live-e2e` entrypoint.
- Run the longer soak budget before release-candidate tagging.
- Confirm no crash, hang, stale rows, duplicate rows, invalid row counts, or
  unbounded process resource growth.

Status:

- In Progress. Test harness commit `92002da` adds the opt-in 10k+ stress
  fixture, `tree-refresh-stress-10k` scenario, tree collapse/expand churn,
  reload/sort/paint churn, aggregate Shared Files UI suite wiring, resource
  snapshots, and targeted Python coverage.
- Pending: live smoke artifact, live soak artifact, REST convergence checks
  during churn, and documented resource thresholds.

### CI-019 - HTTPS and REST socket adversity stress gate

Implementation:

- Add an HTTPS-enabled live REST profile with deterministic certificate/key
  handling.
- Run the existing contract-stress matrix against HTTPS.
- Add raw socket probes for slow TLS handshake, stalled handshake, reset during
  handshake, reset during headers, reset during declared body, and reset during
  response send.
- Add malformed live payload probes for invalid UTF-8 JSON, empty/non-object
  JSON, oversized body, overlong headers, duplicate `Content-Length`,
  conflicting duplicate sensitive headers, wrong method, and unsupported
  content type.
- Add 32-client and 64-client stress budgets for mixed native REST,
  qBit-compatible, Torznab, and legacy HTML requests.

Validation:

- HTTPS contract-stress completes with expected status and envelope behavior.
- Socket adversity cases close or fail deterministically without hangs.
- Accepted-client threads drain and resource deltas remain bounded.
- Latency percentiles and timeout counts are included in the report.

### CI-020 - REST and legacy WebServer error-path coverage gate

Implementation:

- Create a route/error matrix for native `/api/v1`, qBit-compatible `/api/v2`,
  Torznab, and legacy HTML/static-file surfaces.
- Cover 400, 401/403-style auth failures, 404, 405, 409, 500, and 503 branches
  with explicit expected status and envelope/payload rules.
- Add safe fault-injection seams for 500 paths that cannot be triggered
  reliably from black-box traffic.
- Add reset-during-error-response probes to prove queued-send cleanup.
- Fail the route summary on undeclared 4xx/5xx results.

Validation:

- Every release-relevant error branch has an explicit row and result.
- Native REST errors retain the stable typed JSON envelope.
- Legacy HTML/static-file errors are deterministic and stay bounded.
- Fault-injected 500 paths clean up request state.

### CI-021 - WebSocket and legacy socket leak-churn gate

Implementation:

- Add resource baselining for process handles, threads, GDI objects, USER
  objects, private bytes, and accepted WebSocket thread counts.
- Run 1k+ HTTP and 1k+ HTTPS connect/reset cycles across idle, partial-header,
  partial-body, slow-response, and queued-response disconnect cases.
- Add legacy listen-socket churn where it can be done without joining the public
  network.
- Run WebSocket stop/start cycles after churn.
- Emit baseline, peak, and post-drain resource counts.

Validation:

- HTTP and HTTPS churn complete without unbounded resource growth.
- Accepted-client threads drain before global WebSocket termination state is
  closed.
- Stop/start succeeds only after a fully drained state.
- The final report identifies any stuck thread, handle, or queued-send state.

## Release Exit Criteria

All covered items must be `Done` or `Passed` with:

- commit evidence for the harness/test changes
- supported workspace validation command evidence
- smoke artifact evidence
- soak artifact evidence where the item defines an operator soak budget
- documented resource thresholds and observed deltas
