# Controllers And REST Guide

This guide explains how eMule BB should be used with trusted local controllers
and automation.

## REST Is The Default Controller Path

eMule BB exposes a JSON REST API under `/api/v1` through the existing WebServer
listener. REST is the preferred integration surface. The legacy template web UI
is separate and should be enabled explicitly only when needed.

The OpenAPI file is the route and schema authority:

- [REST API contract](../rest/REST-API-CONTRACT.md)
- [OpenAPI contract](../rest/REST-API-OPENAPI.yaml)
- [Adapter contracts](../rest/REST-API-ADAPTERS.md)

## Trust Model

REST is for trusted local or controlled-network automation. Use:

- API key authentication with `X-API-Key`
- deliberate bind address and port
- trusted network path
- firewall rules that match your exposure policy

Do not expose REST broadly on untrusted networks.

## Native Behavior Remains Authoritative

Controllers should preserve eMule semantics:

- search network choice matters
- categories matter
- paused vs started adds matter
- delete operations are meaningful and potentially destructive
- completed files and incomplete parts are different resources
- source/fake/trust feedback should not be discarded

When a controller presents eMule BB like a generic torrent client, the adapter
must still map back to native behavior correctly.

## aMuTorrent

aMuTorrent integration uses eMule BB REST and adapter behavior. Start from a
clean setup, configure the API key and base URL, then prove:

- app status reads correctly
- preferences read correctly
- search dispatch works
- add/download flow reaches eMule BB
- uploads and upload queue data are preserved when consumed
- error envelopes are handled

If browser/UI tests fail, compare aMuTorrent assumptions against the OpenAPI
contract and current live REST smoke evidence.

## Arr, qBit, And Torznab Adapters

Adapter surfaces exist to let Arr-family tools and qBittorrent-compatible flows
talk to eMule BB. These are compatibility layers, not the native contract.

Important expectations:

- native `/api/v1` remains authoritative
- qBit-compatible operations should preserve eMule delete and category semantics
- Torznab search family mapping must dispatch to supported native search types
- adapter errors should remain typed and predictable

## Preference Mutation

REST exposes a curated mutable preference subset. It intentionally does not
allow arbitrary internal preference mutation. Mutable fields must be validated,
persisted, and stable enough for controllers.

Use `GET /api/v1/app/preferences` and `PATCH /api/v1/app/preferences` according
to the OpenAPI contract.

## Lifecycle And Shutdown

REST has lifecycle restrictions. During startup and shutdown, mutating or
unsafe requests can be rejected. This protects native app state and avoids
half-applied operations while the UI thread and services are not fully ready.

Controllers should treat lifecycle errors as retry/stop conditions, not as
permission to hammer the endpoint.

## Legacy WebServer

The legacy WebServer template UI is still useful for compatibility but is not
the preferred automation path. REST should work even when no legacy template is
available. Enable the legacy web server explicitly only when you need it.

## Troubleshooting Controller Issues

For controller failures:

1. Verify WebServer/REST is enabled and bound where expected.
2. Verify the API key.
3. Confirm the route exists in OpenAPI.
4. Check whether the app is starting or shutting down.
5. Compare the adapter request against native route names and field names.
6. Review recent logs and copy a redacted diagnostic snapshot.
7. Run the relevant live REST or adapter smoke test when developing.
