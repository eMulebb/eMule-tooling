# eMule BB REST API Contract

**Status:** beta 0.7.3 broadband contract
**Source of truth:** [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml)
**Legacy parity inventory:** [REST-API-PARITY-INVENTORY.md](REST-API-PARITY-INVENTORY.md)
**Primary implementation:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJson.cpp`
**Route seam:** `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main\srchybrid\WebServerJsonSeams.h`

## Overview

`main` exposes an authenticated in-process JSON API from the existing eMule
WebServer listener. The broadband release contract is the resource-oriented
`/api/v1` surface described by the OpenAPI document above.

The API is designed for aMuTorrent and other trusted local controllers. The
beta 0.7.3 contract intentionally prioritizes consistency and aMuTorrent
completeness over preserving old command-style route names.

## Controller Boundary

aMuTorrent is the primary UI consumer and beta 0.7.3 proof target, but it is not
the authority for native route shape. The aMuTorrent eMule BB adapter must
translate UI expectations to the clean `/api/v1` contract instead of requiring
native aliases, qBittorrent-compatible response shapes, or legacy command-style
routes.

Arr integrations are separate compatibility adapters. Prowlarr Torznab,
Radarr/Sonarr controller flows, and qBittorrent-compatible download-client
routes may keep adapter-specific quirks where those clients require them, but
shared parsing, validation, safety, and serialization should come from the same
native helpers wherever practical. Adapter compatibility must not broaden or
weaken the native `/api/v1` OpenAPI contract. Torznab searches use the native
default `automatic` search method instead of pinning an adapter-only Kad policy.
qBittorrent-compatible transfer delete requests are adapted to native cancel
semantics and therefore forward `deleteFiles: true` to the shared transfer
delete command even when a qBit caller omits or clears its optional flag.

The `/api/v2` surface is a qBittorrent-compatible adapter for Arr download
client integration only. It is complete when Prowlarr, Radarr, Sonarr, and other
Arr clients can authenticate, test the client, add transfers, inspect transfer
state, mutate Arr-relevant transfer state, assign categories, and remove
transfers through the qBittorrent-shaped routes they call. It is not a promise
to implement the full qBittorrent Web API surface, including unrelated RSS,
tracker, peer-management, sync, logging, ban-list, global-speed, or complete
content-layout operations.

## Contract Rules

- root every endpoint at `/api/v1/...`
- authenticate only with `X-API-Key`
- serve JSON only
- inherit the normal WebServer bind, HTTPS, and allowed-IP behavior
- use `camelCase` field names
- return success envelopes as `{ "data": ..., "meta": ... }`
- return collections as `{ "data": { "items": [...], "total": n, "offset": n, "limit": n }, "meta": ... }`
- return errors as `{ "error": { "code": "...", "message": "...", "details": {} } }`
- return the updated resource from mutations when practical
- validate method/path/body/query through the native route schema table before
  dispatching commands
- reject unknown JSON body fields and unknown or malformed query parameters with
  `400 INVALID_ARGUMENT`
- require explicit booleans such as `deleteFiles: true` for destructive local
  file deletion
- use HTTP 200 for valid bulk requests with per-item results
- marshal native commands through the main UI thread before touching eMule
  state owned by dialogs, sockets, queues, and list controls
- keep the route execution model explicit in the native route seam; only
  static/direct-safe routes may bypass the UI-thread dispatch path
- reject pre-release alias spellings; public request fields are the final
  OpenAPI names such as `categoryId`, `searchId`, `deleteFiles`,
  `uploadLimitKiBps`, and `downloadLimitKiBps`

## Scope

The release API must cover every useful runtime action from the legacy
WebServer: transfers, shared files, shared directories, uploads, upload queue,
servers, Kad, searches, friends, logs, categories, statistics, preferences, and
application shutdown. Operator diagnostic dump capture is included for trusted
local release-smoke and support workflows, and remains outside broad automated
mutation/stress loops.

The release API intentionally excludes:

- HTML sessions, login/logout, templates, sort state, column hiding, and other
  legacy WebServer presentation state
- WebServer page-only preferences such as HTML gzip and refresh interval
- host operating-system shutdown and reboot
- binary shared-file streaming
- granular REST permissions or low-rights REST mode
- dynamic capability negotiation between eMule BB and aMuTorrent

## Search Semantics

`POST /api/v1/searches` starts a native eMule search using the requested method:
`automatic`, `server`, `global`, or `kad`. The route maps directly to the
existing eD2K/Kad search modes and must not change stock search semantics for
beta 0.7.3. Search resources echo the resolved method so controllers can
distinguish eD2K server/global searches from Kad searches without inferring from
result timing or counts.

`GET /api/v1/searches/{searchId}` returns the current native visible result
snapshot for that search. Beta 0.7.3 intentionally does not expose search
result paging; the route does not accept `limit` or `offset`, and the strict
route table rejects unknown query parameters. Controllers should poll the search
resource and treat `results` as a bounded native snapshot governed by eMule's
existing search-result retention and visibility behavior. Each native result
also carries the resolved search method when the result is returned through a
search resource.

`POST /api/v1/searches/{searchId}/results/{hash}/operations/download` starts a
download from one visible search result by lowercase 32-character eD2K hash.

`DELETE /api/v1/transfers/{hash}` cancels an incomplete native transfer. eMule
does not preserve partial `.part` state on cancel, so controllers must send
`deleteFiles: true` for incomplete transfers and treat that as native cancel
semantics rather than an optional disk-delete toggle. The route validator
rejects `deleteFiles: false` before dispatch.

## Implementation Status

The OpenAPI contract is the implemented target contract for the current
beta 0.7.3 pass. Native route-seam tests cover the route schema table, strict
validation behavior, and the internal route execution model. The Python smoke
harness includes OpenAPI route consistency checks, validates success/error
envelopes, and reports whether each native route is direct or UI-thread
dispatched. aMuTorrent's eMule BB adapter consumes the same final field names
while keeping aMuTorrent's own public routes stable.

## Controller Compatibility Matrix

| Consumer | Surface | Contract boundary | Proof lane |
|---|---|---|---|
| Native REST clients | `/api/v1` | OpenAPI is authoritative; adapters do not define route names or envelopes. | REST smoke, OpenAPI drift, live completeness |
| aMuTorrent | `/api/v1` through its own adapter | Translates UI expectations to final native fields and unwraps native envelopes. | aMuTorrent browser smoke |
| Prowlarr Torznab | Torznab XML adapter | Keeps Torznab XML/error shape adapter-local while reusing native parsing and search commands. | Prowlarr live |
| Radarr/Sonarr | Torznab plus qBit-compatible download client | Uses Arr-facing compatibility routes without broadening `/api/v1`. | Radarr/Sonarr live |
| qBittorrent-compatible clients | `/api/v2` | Implements the Arr-needed qBit subset only; qBit text/session errors stay adapter-shaped. | qBit route completeness and Arr live |

## Execution Model

The native route table records whether a route is direct or UI-thread
dispatched. `GET /api/v1/app` is currently the only direct route because it
serves static application identity/build metadata. Runtime reads, mutations,
destructive operations, and adapter bridges remain UI-thread dispatched until
ownership is proven safe at the implementation layer.

Use [REST-API-PARITY-INVENTORY.md](REST-API-PARITY-INVENTORY.md) for residual
release-gate and live-smoke tracking. Runtime route completeness is expected to
match [REST-API-OPENAPI.yaml](REST-API-OPENAPI.yaml).

## Retired Before Public Release

The following earlier command-style routes are not part of the final broadband
release contract and should not be used by aMuTorrent:

- `/api/v1/app/version`
- `/api/v1/stats/global`
- `/api/v1/transfers/add`
- `/api/v1/transfers/pause`
- `/api/v1/transfers/resume`
- `/api/v1/transfers/stop`
- `/api/v1/transfers/delete`
- `/api/v1/uploads/list`
- `/api/v1/uploads/queue`
- `/api/v1/servers/list`
- `/api/v1/servers/status`
- `/api/v1/search/start`
- `/api/v1/search/results`
- `/api/v1/search/stop`
- `/api/v1/log`
