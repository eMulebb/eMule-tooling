---
id: FEAT-014
title: REST API — emule-sidecar (Node.js/TypeScript HTTP sidecar)
status: Open
priority: Minor
category: feature
labels: [api, rest, nodejs, typescript, sse, sidecar]
milestone: ~
created: 2026-04-08
source: PLAN-API-SERVER.md (PLAN_004 — sidecar side)
---

## Summary

Implement `emule-sidecar` — a standalone Node.js/TypeScript process that connects to `CPipeApiServer` (FEAT-013) via `\\.\pipe\emule-api` and exposes a full `/api/v2/...` REST API with Server-Sent Events (SSE) for push notifications.

This is the Node.js half of the REST API architecture. The full contract is specified in `docs/PLAN-API-SERVER.md`.

## Why a Sidecar

| Concern | In-process C++ REST | Named Pipe + Sidecar |
|---------|--------------------|-----------------------|
| eMule crash kills API | Yes | No — sidecar survives |
| API changes require rebuild | Yes | No — sidecar independent |
| Real-time push (SSE) | Painful in C++ | Trivial in Node |
| TLS / HTTPS | Heavy | Handled by Fastify |
| OpenAPI / tooling | Manual | Auto-generated |

## Technology Stack

| Component | Choice | Reason |
|-----------|--------|--------|
| HTTP framework | Fastify | Fast, TypeScript-native, plugin ecosystem |
| SSE | `@fastify/sse-plugin` or native Response streams | Simple push to HTTP clients |
| Pipe client | Node.js `net.Socket` | Built-in, no deps |
| JSON | Native `JSON.parse` / `JSON.stringify` | Built-in |
| Schema validation | Zod | Type-safe, integrates with Fastify |
| Auth | JWT or API-key header | Configurable in sidecar config |

## Project Structure

```
emule-sidecar/
├── src/
│   ├── pipe/
│   │   ├── PipeClient.ts        # Named pipe connect, JSON-lines framing, reconnect
│   │   └── EventBus.ts          # Internal event dispatcher
│   ├── api/
│   │   ├── app.ts               # Fastify instance, plugin registration
│   │   ├── routes/
│   │   │   ├── auth.ts          # POST /api/v2/auth/login
│   │   │   ├── app.ts           # GET/POST /api/v2/app/*
│   │   │   ├── stats.ts         # GET /api/v2/stats
│   │   │   ├── transfers.ts     # GET/POST /api/v2/transfers*
│   │   │   ├── uploads.ts       # GET /api/v2/uploads
│   │   │   ├── servers.ts       # GET/POST /api/v2/servers/*
│   │   │   ├── kad.ts           # GET /api/v2/kad
│   │   │   ├── shared.ts        # GET /api/v2/shared
│   │   │   ├── log.ts           # GET /api/v2/log
│   │   │   ├── search.ts        # POST/DELETE /api/v2/search
│   │   │   └── events.ts        # GET /api/v2/events (SSE)
│   │   └── middleware/
│   │       └── auth.ts          # JWT / API-key check
│   ├── sse/
│   │   └── SseManager.ts        # Fan-out EventBus events to SSE clients
│   └── main.ts                  # Entry point
├── package.json
├── tsconfig.json
└── emule-sidecar.config.json    # Port, auth secret, log level
```

## REST API Endpoints

### Auth
| Method | Path | Action |
|--------|------|--------|
| POST | `/api/v2/auth/login` | Returns JWT token |

### Application
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/app/version` | eMule version, config |
| POST | `/api/v2/app/shutdown` | Graceful shutdown |

### Stats
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/stats` | Speed, connections, session totals, kad status |

### Transfers
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/transfers` | All downloads with progress/speed/ETA |
| POST | `/api/v2/transfers` | Add ed2k:// link or .met payload |
| DELETE | `/api/v2/transfers/:hash` | Cancel download |
| PATCH | `/api/v2/transfers/:hash` | Pause / resume |

### Uploads
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/uploads` | Current upload slots |

### Servers
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/servers` | Known servers |
| POST | `/api/v2/servers/connect` | Connect to server |

### Kad
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/kad` | Kad status, routing table size |

### Shared
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/shared` | Shared file list with metadata |

### Log
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/log` | Last N log lines |

### Search
| Method | Path | Action |
|--------|------|--------|
| POST | `/api/v2/search` | Start keyword search |
| DELETE | `/api/v2/search/:id` | Cancel search |

### Events (SSE)
| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v2/events` | SSE stream — `stats`, `file_complete`, `server_connect`, `search_result` |

## Pipe Client Behavior

- Connects to `\\.\pipe\emule-api` on startup
- Auto-reconnect with exponential backoff (1s → 2s → 4s → max 30s) if pipe closes
- UUID-based request/response matching (correlation via `id` field)
- Pending requests time out after 10 s if no response arrives
- Unsolicited `event` messages dispatched to `EventBus` → `SseManager`

## HTTP Error Convention

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Bad request (validation error) |
| 401 | Unauthorized (bad/missing token) |
| 404 | Resource not found |
| 409 | Conflict (e.g., duplicate download) |
| 503 | eMule pipe not connected |

## Configuration File (`emule-sidecar.config.json`)

```json
{
  "port": 7654,
  "host": "127.0.0.1",
  "auth": {
    "secret": "change-me",
    "tokenExpiry": "24h"
  },
  "pipe": {
    "name": "\\\\.\\pipe\\emule-api",
    "reconnectMaxDelay": 30000
  },
  "log": {
    "level": "info"
  }
}
```

## Implementation Order

1. `PipeClient.ts` — connect, framing, request/response matching, reconnect
2. `EventBus.ts` + `SseManager.ts` — event fan-out to SSE clients
3. `/api/v2/stats` route — validates the full round-trip
4. `/api/v2/events` SSE stream — validates push path
5. `/api/v2/transfers` — most important for remote control
6. Remaining routes

## Acceptance Criteria

- [ ] `emule-sidecar` starts independently; reconnects to pipe after eMule restart
- [ ] `GET /api/v2/stats` returns live data within 2 s of connection
- [ ] `GET /api/v2/events` delivers `stats` events every ~1 s
- [ ] `GET /api/v2/events` delivers `file_complete` event when download finishes
- [ ] `POST /api/v2/transfers` with valid ed2k:// link starts the download in eMule
- [ ] Auth header required on all routes except `/api/v2/auth/login`
- [ ] OpenAPI spec auto-generated from Fastify route schemas

## Prerequisite

FEAT-013 (CPipeApiServer — the C++ pipe server must exist before the sidecar can connect)

## Reference

Full API contract: `docs/PLAN-API-SERVER.md`
C++ pipe server: FEAT-013
