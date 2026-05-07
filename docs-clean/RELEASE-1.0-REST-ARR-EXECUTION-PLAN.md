# Release 1.0 REST and Arr Execution Plan

This is the active execution plan for Release 1 REST, aMuTorrent, and Arr work. It
does not own gate status; use [RELEASE-1.0](RELEASE-1.0.md) for current release
decisions and item docs for completion evidence.

Current status: the broadband branch remains pre-release stabilization. This
plan describes the REST/Arr shape that supports Release 1; it is not a tag or
package authorization document.

## Decisions

- Native `/api/v1` cleanliness wins over current client compatibility.
- Breaking pre-release REST contracts is allowed when it makes eMule BB
  cleaner.
- aMuTorrent adapts to the native REST API; it does not define that API.
- Arr compatibility is an adapter layer over shared native logic.
- Legacy WebServer cleanup is limited to REST/WebServer boundary safety and
  shared request/path/concurrency code.
- Do not rewrite or retire the legacy HTML UI for Release 1.

## Gate Map

| Area | Release gate items | Deep-plan responsibility |
|------|--------------------|--------------------------|
| Native REST errors | [BUG-075](BUG-075.md) | stable JSON error envelope and status mapping |
| WebServer boundary | [BUG-076](BUG-076.md), [BUG-077](BUG-077.md) | malformed REST isolation and mixed REST/legacy stress |
| Contract completeness | [CI-014](CI-014.md), [CI-015](CI-015.md), [FEAT-047](FEAT-047.md) | OpenAPI-backed smoke, route drift checks, stress budgets |
| aMuTorrent | [AMUT-001](AMUT-001.md), [AMUT-002](AMUT-002.md) | UI consumer proof and transfer-detail deferral boundary |
| Arr adapters | [ARR-001](ARR-001.md) | Torznab/qBittorrent adapter proof without native API drift |
| REST controller candidates | [FEAT-045](FEAT-045.md), [FEAT-046](FEAT-046.md), [FEAT-048](FEAT-048.md), [FEAT-049](FEAT-049.md) | documented deferral or promotion path for controller parity work |

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
- Shared behavior should reuse native parser, validation, normalization,
  serialization, and path-safety helpers.
- aMuTorrent and Arr gates must not force native route names or envelope shape.

## Execution Lanes

### REST and WebServer Robustness

- Keep [BUG-075](BUG-075.md) as the typed error contract owner.
- Keep [BUG-076](BUG-076.md) as the malformed request boundary owner.
- Keep [BUG-077](BUG-077.md) as the mixed REST and legacy HTML stress owner.
- Any future route, parser, auth, or WebServer concurrency change must rerun the
  REST smoke and malformed/concurrent matrix before Release 1 evidence is
  reused.

### Contract Completeness

- Keep [CI-014](CI-014.md) as the OpenAPI and route drift gate.
- Keep [CI-015](CI-015.md) as the malformed and concurrent request matrix gate.
- Keep [FEAT-047](FEAT-047.md) closed by documenting the Release 1 search
  snapshot behavior instead of adding paging or bounds changes.
- New `/api/v1` routes require OpenAPI, native route seam, live smoke, and
  REST contract documentation updates in the same closure slice.

### Controller Integrations

- Keep [AMUT-001](AMUT-001.md) as the live aMuTorrent browser proof.
- Keep [ARR-001](ARR-001.md) as the live Prowlarr, Radarr, Sonarr, Torznab,
  and qBittorrent-compatible proof.
- Treat [AMUT-002](AMUT-002.md) as deferred unless [FEAT-045](FEAT-045.md) is
  promoted and the aMuTorrent smoke stops providing useful release transfer
  views.

### Candidate Promotion Rules

- [FEAT-045](FEAT-045.md) is promoted only if Release 1 controller views need a
  dedicated transfer detail endpoint.
- [FEAT-046](FEAT-046.md) is promoted only if live-wire bootstrap requires Kad
  import before the first release.
- [FEAT-048](FEAT-048.md) is promoted only if a release controller or live E2E
  lane needs upload queue mutations beyond the current surface.
- [FEAT-049](FEAT-049.md) is promoted only for settings required by aMuTorrent
  or release automation and safe to expose through curated preferences.

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

- [FEAT-045](FEAT-045.md): transfer detail endpoint
- [FEAT-046](FEAT-046.md): server/Kad bootstrap/import APIs
- [FEAT-048](FEAT-048.md): upload queue control completeness
- [FEAT-049](FEAT-049.md): curated REST preference expansion
- [AMUT-002](AMUT-002.md): aMuTorrent transfer detail hydration

These remain candidates for later controller work unless a future Release 1
gate failure proves that one is required.
