---
id: FEAT-013
title: REST API — extend WebServer.cpp with authenticated JSON endpoints
status: Open
priority: Major
category: feature
labels: [api, rest, webserver, json, http, https]
milestone: ~
created: 2026-04-08
source: 2026-04-12 backlog review pivot from pipe/sidecar-first plan
---

## Summary

If REST support is added in the current stabilization phase, the primary implementation
should extend the existing `WebServer.cpp` / `WebSocket.cpp` stack instead of introducing
an internal named-pipe protocol first.

This keeps the feature close to the existing web surface, minimizes architecture drift,
reuses the current HTTP/HTTPS listener, and avoids adding a second transport and dispatch
stack during the hardening milestone.

## Preferred Architecture

```
eMule.exe
  WebSocket.cpp      -> existing HTTP/HTTPS accept + TLS
  WebServer.cpp      -> route parsing and auth/session handling
  WebServerJson.cpp  -> optional helper split for JSON serializers/route handlers
                      -> /api/v1/... JSON endpoints
```

### Keep

- existing HTML web interface routes
- existing password/session model as the first auth layer
- existing HTTPS support in `WebSocket.cpp`

### Add

- authenticated JSON responses for machine clients
- small route/serializer helpers around the existing WebServer request flow
- targeted admin-only mutation routes

### Avoid in phase 1

- named-pipe-first transport
- Node/TypeScript sidecar as the primary architecture
- async socket migration
- SSE/WebSocket push unless a narrow polling API proves insufficient

## Initial Route Set

### Read-only

- `GET /api/v1/app/version`
- `GET /api/v1/stats`
- `GET /api/v1/transfers`
- `GET /api/v1/uploads`
- `GET /api/v1/servers`
- `GET /api/v1/kad`
- `GET /api/v1/shared`
- `GET /api/v1/log?limit=N`

### Mutating

- `POST /api/v1/transfers`
  add an `ed2k://` link
- `POST /api/v1/transfers/{hash}/pause`
- `POST /api/v1/transfers/{hash}/resume`
- `DELETE /api/v1/transfers/{hash}`
- `POST /api/v1/servers/connect`

## Authentication Model

- reuse existing web password/session handling first
- require authenticated session for all JSON routes
- require admin session for mutation routes
- do not create a second independent auth store in phase 1

## Compatibility Goals

- HTML web UI remains behavior-compatible
- JSON endpoints are additive
- no dependency on sidecars or external runtimes
- no dependency on async socket refactors

## Implementation Notes

- route JSON requests inside the existing WebServer dispatch path
- keep serialization isolated from HTML template rendering
- prefer stable identifiers already used by the app:
  - MD4 hash for transfers/shared files
  - server address/port for server actions
- keep all UI-thread/state access rules identical to current WebServer behavior

## Test Requirements

- targeted WebServer route tests for:
  - unauthenticated request rejection
  - admin vs low-privilege access
  - JSON schema sanity for stats/transfers/shared routes
  - add/pause/resume/delete transfer actions
- regression coverage proving legacy HTML pages still render after JSON routes land
- HTTPS route smoke coverage using configured cert/key files on non-ASCII paths

## Acceptance Criteria

- [ ] Existing HTML web interface still works unchanged
- [ ] `/api/v1/stats` and `/api/v1/transfers` return stable JSON
- [ ] Mutation routes require admin-authenticated web session
- [ ] HTTPS works for REST routes through the existing `WebSocket.cpp` stack
- [ ] No new transport, sidecar, or async socket dependency is introduced

## Relationship To Other Items

- **FEAT-014** becomes an optional follow-up layer, not the primary architecture
- **CI-008** should carry the WebServer/REST regression expansion for this item
- **REF-029** stays explicitly deferred; do not couple REST delivery to socket-stack replacement
