---
id: FEAT-013
title: REST API — add authenticated in-process JSON endpoints to WebServer
status: Done
priority: Major
category: feature
labels: [api, rest, webserver, json, http, https]
milestone: ~
created: 2026-04-08
updated: 2026-04-19
source: 2026-04-12 backlog review pivot from pipe/sidecar-first plan
landed_in:
  - repo: eMule-main
    branch: main
    commit: 8d0832a
---

## Summary

`main` now exposes an authenticated in-process REST surface under `/api/v1/...`
by extending the existing `WebServer.cpp` / `WebSocket.cpp` stack.

The implementation deliberately does **not** port the experimental named-pipe
transport or Node sidecar as runtime architecture. Instead it:

- reuses the current WebServer listener, bind address, port, and HTTPS support
- adds a dedicated JSON route layer in `WebServerJson.cpp`
- vendors the experimental `nlohmann/json.hpp` single-header library
- adapts the experimental command/serializer logic directly in-process

## Landed Shape

### Transport and auth

- shared existing WebServer HTTP/HTTPS listener
- no second REST-specific port or listener
- REST auth uses `X-API-Key`
- REST key is stored hashed in preferences, separate from HTML web-session auth
- HTML web UI remains intact and does not use the REST key

### Route surface

The landed route surface follows the experimental API parity target:

- `GET /api/v1/app/version`
- `GET /api/v1/app/preferences`
- `POST /api/v1/app/preferences`
- `POST /api/v1/app/shutdown`
- `GET /api/v1/stats/global`
- `GET /api/v1/transfers`
- `GET /api/v1/transfers/{hash}`
- `GET /api/v1/transfers/{hash}/sources`
- `POST /api/v1/transfers/add`
- `POST /api/v1/transfers/pause`
- `POST /api/v1/transfers/resume`
- `POST /api/v1/transfers/stop`
- `POST /api/v1/transfers/delete`
- `POST /api/v1/transfers/{hash}/recheck`
- `POST /api/v1/transfers/{hash}/priority`
- `POST /api/v1/transfers/{hash}/category`
- `GET /api/v1/uploads/list`
- `GET /api/v1/uploads/queue`
- `POST /api/v1/uploads/remove`
- `POST /api/v1/uploads/release_slot`
- `GET /api/v1/servers/list`
- `GET /api/v1/servers/status`
- `POST /api/v1/servers/connect`
- `POST /api/v1/servers/disconnect`
- `POST /api/v1/servers/add`
- `POST /api/v1/servers/remove`
- `GET /api/v1/kad/status`
- `POST /api/v1/kad/connect`
- `POST /api/v1/kad/disconnect`
- `POST /api/v1/kad/recheck_firewall`
- `GET /api/v1/shared/list`
- `GET /api/v1/shared/{hash}`
- `POST /api/v1/shared/add`
- `POST /api/v1/shared/remove`
- `POST /api/v1/search/start`
- `GET /api/v1/search/results`
- `POST /api/v1/search/stop`
- `GET /api/v1/log?limit=N`

### Supporting runtime changes

- `WebSocket.cpp` now preserves request method, request target, request body, and
  `X-API-Key` header for downstream dispatch
- `Log.cpp` / `Log.h` keep a bounded recent-log buffer so `/api/v1/log` can
  return recent entries without scraping UI controls
- `SearchResultsWnd` / `SearchList` expose the narrow helpers needed for
  machine-readable search start/status/result retrieval
- WebServer options now include a dedicated API-key field
- the experimental `uploadClientDataRate` / `maxUploadSlots` preference knobs
  are mapped onto the current broadband upload-budget controller instead of
  reviving the stale experimental preference storage directly

## Explicit Non-Goals In This Slice

- no named-pipe transport
- no Node/TypeScript sidecar
- no public SSE or WebSocket push endpoint
- no separate REST privilege split beyond possession of the configured API key

## Follow-Up Work

- `FEAT-014` remains the follow-up item for OpenAPI docs and any optional
  external gateway/tooling around the landed in-process REST surface
- `CI-008` remains the follow-up item for explicit regression coverage of the
  new REST routes

## Acceptance Notes

- existing HTML web UI remains present
- REST is additive and JSON-only under `/api/v1/...`
- HTTPS continues to flow through the existing `WebSocket.cpp` listener
- experimental command semantics were reused, but the transport architecture was
  intentionally simplified to in-process WebServer routing
