# eMule BB REST Adapter Contracts

**Status:** beta 0.7.3 adapter subset contract
**Native contract:** [REST-API-CONTRACT.md](REST-API-CONTRACT.md)

## Purpose

Native `/api/v1` is the only clean JSON REST contract. The compatibility
adapters below exist so Arr-family tools can talk to eMule BB without forcing
native v1 to mimic qBittorrent or Torznab quirks.

The legacy template-based WebServer UI is deprecated and compile-only. It is
not an adapter contract, and no functional HTML/template behavior is guaranteed
for beta 0.7.3 beyond preserving shared listener buildability.

## qBittorrent-Compatible `/api/v2`

`/api/v2` is an Arr download-client compatibility subset, not a full
qBittorrent Web API clone. It uses qBittorrent-shaped content types, text
responses, session cookies, and form bodies where Arr clients expect them.

Supported routes:

| Method | Route | Auth | Contract role |
|---|---|---|---|
| `GET` | `/api/v2/app/webapiVersion` | no | Public qBit Web API version probe. |
| `POST` | `/api/v2/auth/login` | no | Form login using the configured eMule BB API key as password. |
| `GET` | `/api/v2/app/version` | yes | App version probe. |
| `GET` | `/api/v2/app/preferences` | yes | Minimal preference payload for Arr client tests. |
| `GET` | `/api/v2/torrents/categories` | yes | Category map. |
| `POST` | `/api/v2/torrents/createCategory` | yes | Create a native category from qBit form field `category`. |
| `GET` | `/api/v2/torrents/info` | yes | Transfer list, optionally filtered by `category`. |
| `GET` | `/api/v2/torrents/properties` | yes | One transfer's qBit-shaped properties by `hash`. |
| `GET` | `/api/v2/torrents/files` | yes | One transfer's qBit-shaped file list by `hash`. |
| `POST` | `/api/v2/torrents/add` | yes | Add one Torznab-emitted magnet converted back to an eD2K link. |
| `POST` | `/api/v2/torrents/delete` | yes | Delete/cancel transfers by `hashes`; always maps to native `deleteFiles: true`. |
| `POST` | `/api/v2/torrents/setCategory` | yes | Assign a native category by `hashes` and `category`. |
| `POST` | `/api/v2/torrents/pause` | yes | Pause transfers by `hashes`. |
| `POST` | `/api/v2/torrents/stop` | yes | Stop transfers by `hashes`. |
| `POST` | `/api/v2/torrents/resume` | yes | Resume transfers by `hashes`. |
| `POST` | `/api/v2/torrents/start` | yes | Start/resume transfers by `hashes`. |
| `POST` | `/api/v2/torrents/setShareLimits` | yes | Accepted no-op for Arr compatibility after validating `hashes`. |
| `POST` | `/api/v2/torrents/topPrio` | yes | Accepted no-op for Arr compatibility after validating `hashes`. |
| `POST` | `/api/v2/torrents/setForceStart` | yes | Accepted no-op after validating `hashes` and optional boolean `value`. |

Unsupported qBittorrent families remain outside the adapter contract: RSS,
tracker editing, peer management, sync, logging, ban lists, global speed
controls, and full content-layout operations.

## Torznab `/indexer/emulebb/api`

The Torznab adapter is a Prowlarr/Radarr/Sonarr search bridge. It emits XML and
uses adapter-shaped status codes and bodies; it never returns native v1 JSON
envelopes.

Supported request shape:

| Field | Contract |
|---|---|
| `t` | `caps`, `search`, `tvsearch`, or `movie`; missing or empty defaults to `search`. |
| `apikey` | Optional query API key. If omitted, `X-API-Key` may authenticate the request. |
| `q` | Search text, normalized through native REST search validation. |
| `cat` | Comma-separated Torznab categories mapped to native eMule file families. |
| `season`, `ep`, `year` | Optional unsigned decimal filters bounded to `0..9999`. |

Supported responses:

- `200 application/xml` for caps and accepted searches.
- `400 application/xml` for malformed query parameters or unsupported request
  types.
- `401 application/xml` for missing or invalid API keys.
- `503 application/xml` when the native REST API key is not configured.

Searches dispatch to the same native default `automatic` search method used by
`POST /api/v1/searches`; Torznab does not define a separate Kad-only policy.
