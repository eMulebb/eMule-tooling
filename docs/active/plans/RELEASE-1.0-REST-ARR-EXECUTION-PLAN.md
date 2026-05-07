# Release 1.0 REST and Arr Execution Plan

This is the active execution plan for Release 1 REST, aMuTorrent, and Arr work. It
does not own gate status; use [RELEASE-1.0](../RELEASE-1.0.md) for current release
decisions and item docs for completion evidence.

Current status: the broadband branch remains pre-release stabilization. This
plan describes the REST/Arr shape that supports Release 1; it is not a tag or
package authorization document.

## Decisions

- Native `/api/v1` cleanliness wins over current client compatibility.
- Breaking pre-release REST contracts is allowed when it makes eMule BB
  cleaner.
- aMuTorrent is the primary UI target, but it adapts to the clean native
  `/api/v1` design; it does not define route names, envelopes, field aliases,
  validation rules, or compatibility drift.
- Arr compatibility is an adapter layer over shared native logic.
- Prowlarr/Radarr/Sonarr/qBittorrent-compatible behavior is release-critical
  evidence, but it must not force native `/api/v1` to mimic Arr or qBit quirks.
- Legacy WebServer cleanup is limited to REST/WebServer boundary safety and
  shared request/path/concurrency code.
- Do not rewrite or retire the legacy HTML UI for Release 1.

## Gate Map

| Area | Release gate items | Deep-plan responsibility |
|------|--------------------|--------------------------|
| Native REST errors | [BUG-075](../items/BUG-075.md) | stable JSON error envelope and status mapping |
| WebServer boundary | [BUG-076](../items/BUG-076.md), [BUG-077](../items/BUG-077.md) | malformed REST isolation and mixed REST/legacy stress |
| Contract completeness | [CI-014](../items/CI-014.md), [CI-015](../items/CI-015.md), [FEAT-047](../items/FEAT-047.md) | OpenAPI-backed smoke, route drift checks, stress budgets |
| aMuTorrent | [AMUT-001](../items/AMUT-001.md), [AMUT-002](../items/AMUT-002.md) | UI consumer proof and transfer-detail deferral boundary |
| Arr adapters | [ARR-001](../items/ARR-001.md) | Torznab/qBittorrent adapter proof without native API drift |
| REST controller candidates | [FEAT-045](../items/FEAT-045.md), [FEAT-046](../items/FEAT-046.md), [FEAT-048](../items/FEAT-048.md), [FEAT-049](../items/FEAT-049.md) | documented deferral or promotion path for controller parity work |

## Current Revalidation Focus

The earlier gates have passing evidence, but the next Release 1 hardening pass
should revalidate the API surfaces below before treating that evidence as fresh.

### Native `/api/v1`

- [ ] Re-run the OpenAPI route-drift check against every implemented native
      route, including methods, required bodies, path parameters, and response
      envelopes.
- [ ] Re-run live REST completeness with representative read routes, safe
      mutations, destructive confirmation bodies, and unsupported-method checks.
- [ ] Re-run malformed-input coverage for bad JSON, non-object JSON, unknown
      fields, malformed query parameters, bad hashes, missing auth, wrong auth,
      unsupported content types, missing resources, and invalid state.
- [ ] Re-run mixed REST/legacy WebServer stress with native `/api/v1` errors
      checked for JSON-only responses and no HTML fallback.
- [ ] Audit every destructive native operation for explicit confirmation or
      explicit intent fields, especially transfer delete, shared-file delete,
      delete-all searches, clear-completed transfers, directory replacement, and
      app shutdown exclusion from broad mutation loops.

### Arr And qBit-Compatible Adapters

- [ ] Revalidate Prowlarr Torznab indexer add/test/search against live eMule BB
      and confirm adapter errors are bounded, redacted, and diagnosable.
- [ ] Revalidate Radarr and Sonarr indexer sync through Prowlarr plus
      qBittorrent-compatible download-client add/test flows.
- [ ] Revalidate qBittorrent-compatible login, app preferences, transfer add,
      transfer info/properties/files, category mutation, pause/resume, and
      delete flows against live eMule BB.
- [ ] Confirm adapter compatibility parsing reuses shared native validation,
      normalization, path-safety, and serialization helpers where applicable
      instead of carrying divergent behavior.
- [ ] Confirm Arr/qBit compatibility errors stay adapter-shaped for those
      clients while native `/api/v1` remains the clean OpenAPI-shaped contract.

### aMuTorrent Consumer Proof

- [ ] Re-run the aMuTorrent browser smoke after native `/api/v1` and adapter
      revalidation so UI regressions are caught without making aMuTorrent the
      native API authority.
- [ ] Confirm the eMule BB adapter keeps translating aMuTorrent expectations to
      final native fields/routes and does not require native aliases for old UI
      state.
- [ ] Confirm status, ED2K/Kad search selection, progress formatting, and
      download-row delete remain covered by the aMuTorrent integration branch.

## Native REST Contract

- Native REST failures return JSON, not legacy HTML.
- Destructive native operations require explicit confirmation bodies.
- Native `/api/v1` hashes stay strict lowercase eD2K identifiers.
- Search result paging is intentionally not exposed in Release 1; controllers
  poll the current visible native result snapshot.
- `/app/shutdown` stays excluded from broad live mutation loops.

## Adapter Boundaries

- qBit-compatible hash inputs may normalize for compatibility, but native
  `/api/v1` remains strict.
- Torznab XML/feed shape and qBit text/session-cookie behavior stay
  adapter-specific.
- Transfer progress ratio math is shared by native `/api/v1` and qBit-compatible
  transfer rows so UI adapters see bounded precision without defining the
  native contract.
- Shared behavior should reuse native parser, validation, normalization,
  serialization, and path-safety helpers.
- aMuTorrent and Arr gates must not force native route names or envelope shape.

## Execution Lanes

### REST and WebServer Robustness

- Keep [BUG-075](../items/BUG-075.md) as the typed error contract owner.
- Keep [BUG-076](../items/BUG-076.md) as the malformed request boundary owner.
- Keep [BUG-077](../items/BUG-077.md) as the mixed REST and legacy HTML stress owner.
- Any future route, parser, auth, or WebServer concurrency change must rerun the
  REST smoke and malformed/concurrent matrix before Release 1 evidence is
  reused.

### Contract Completeness

- Keep [CI-014](../items/CI-014.md) as the OpenAPI and route drift gate.
- Keep [CI-015](../items/CI-015.md) as the malformed and concurrent request matrix gate.
- Keep [FEAT-047](../items/FEAT-047.md) closed by documenting the Release 1 search
  snapshot behavior instead of adding paging or bounds changes.
- New `/api/v1` routes require OpenAPI, native route seam, live smoke, and
  REST contract documentation updates in the same closure slice.

### Controller Integrations

- Keep [AMUT-001](../items/AMUT-001.md) as the live aMuTorrent browser proof.
- Keep [ARR-001](../items/ARR-001.md) as the live Prowlarr, Radarr, Sonarr, Torznab,
  and qBittorrent-compatible proof.
- Treat [AMUT-002](../items/AMUT-002.md) as deferred unless [FEAT-045](../items/FEAT-045.md) is
  promoted and the aMuTorrent smoke stops providing useful release transfer
  views.

### Candidate Promotion Rules

- [FEAT-045](../items/FEAT-045.md) is promoted only if Release 1 controller views need a
  dedicated transfer detail endpoint.
- [FEAT-046](../items/FEAT-046.md) is closed for Release 1: server.met import,
  Kad bootstrap, nodes.dat URL import, malformed preservation, and live seed
  import evidence are covered.
- [FEAT-048](../items/FEAT-048.md) is closed for Release 1 by audit: existing
  upload controls are covered, unsupported operations return typed errors, and
  no additional queue mutation was promoted.
- [FEAT-049](../items/FEAT-049.md) is closed for Release 1 by audit: aMuTorrent
  needs no additional runtime preference keys, risky internals remain private,
  and the curated surface has live round-trip plus bad-value coverage.

## Release Test Matrix

- native route and OpenAPI drift tests
- REST smoke with representative read and safe mutation routes
- REST malformed-request coverage
- REST mixed stress and soak budgets
- aMuTorrent browser smoke with console/page/request diagnostics
- Prowlarr Torznab live proof
- Radarr/Sonarr integration through Prowlarr plus qBit-compatible download
  control
- long-path and Unicode REST paths for shared directories, transfers, and logs

## Deferred REST/Arr Work

- [FEAT-045](../items/FEAT-045.md): transfer detail endpoint
- [AMUT-002](../items/AMUT-002.md): aMuTorrent transfer detail hydration

These remain candidates for later controller work unless a future Release 1
gate failure proves that one is required.
