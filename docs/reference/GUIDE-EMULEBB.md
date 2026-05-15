# eMule BB Product Guide

eMule broadband edition, compactly eMule BB, keeps the classic eMule desktop
workflow while making the client more practical on modern Windows machines,
fast upload links, large shared libraries, and trusted local automation stacks.

This guide is the long-form companion to the public web page. It explains how
to think about the product and where to go for deeper engineering references.

## Who It Is For

eMule BB is aimed at users who already understand why eD2K/Kad is useful:

- power users running long-lived desktop sessions
- archivists and seeders with large shared directories
- users with broadband upload capacity that stock slot behavior does not model well
- operators who want local controller access without giving up the native app
- contributors who want release evidence, not just a compiled binary

The product is intentionally not a rewrite. Stock protocol compatibility and the
familiar eMule workflow remain the baseline.

## First-Run Model

Start by treating eMule BB like eMule:

1. Use trusted server lists and known-good Kad bootstrap sources.
2. Review IP filter status and update sources if you use IP filtering.
3. Keep incoming, temporary, and shared directories predictable.
4. Organize downloads with categories before adding automation.
5. Confirm server/global/Kad search behavior in the desktop app.
6. Let the client run long enough to build useful queue and known-client state.

Only add REST controllers once the native app is behaving as expected.

## Stock Data Compatibility

Existing stock eMule profiles should generally drop into eMule BB for the
important identity, download, server, Kad, and known-file state. eMule BB keeps
the core persistence formats compatible for `preferences.dat`, `clients.met`,
`cryptkey.dat`, `known.met`, `known2.met`, `cancelled.met`, `.part.met`,
`server.met`, and `nodes.dat`.

The reverse direction is not a perfect round trip after eMule BB has run. Stock
eMule ignores BB-only `preferences.ini` keys, and older stock builds may not
handle Unicode/BOM-written path lists such as `shareddir.dat` and
`sharedfiles.dat` the same way. eMule BB also writes local sidecars that stock
does not understand: `shareignore.dat`, `shareddir.monitored.dat`,
`shareddir.monitor-owned.dat`, `sharedcache.dat`, and `shareddups.dat`.

Most sidecars are harmless if ignored or deleted, especially the shared-library
startup caches. The meaningful rollback difference is sharing policy: stock
does not know BB's share-ignore rules or monitored-share ownership, so it may
treat monitor-owned shared directories as ordinary shares and will not preserve
why those directories were present.

## Broadband Upload Tuning

The broadband controller is designed for finite, realistic upload budgets.
Instead of growing upload slots toward a large legacy cap, it works from a
configured upload budget and a target number of upload clients.

Practical guidance:

- Set a finite upload limit that leaves headroom for the machine and network.
- Choose a maximum upload client count that matches your goal: fewer stronger
  slots for high-bandwidth seeding, more slots only when you have a reason.
- Watch slow or stuck slots over time rather than reacting to short bursts.
- Use ratio readouts to understand whether rare files are getting useful upload
  attention.

For the implementation background, see
[FEATURE-BROADBAND](FEATURE-BROADBAND.md).

## Large Library Operation

Large libraries need boring discipline more than novelty:

- keep share roots clean and avoid broad accidental directories
- use long-path capable Windows setups for deep directory trees
- keep temporary, incoming, and completed paths distinct
- let recursive share sync and startup cache behavior settle before judging performance
- use stable sorting and ratio columns when curating rare or under-shared files

For long-path details, see [GUIDE-LONGPATHS](GUIDE-LONGPATHS.md).

For IP filter storage, update sources, and supported filter formats, see
[GUIDE-IP-FILTERS](GUIDE-IP-FILTERS.md).

## Search And Sharing Workflow

eMule BB keeps native eD2K/Kad behavior central:

- use server search when a trusted server path is enough
- use global search when server coverage matters
- use Kad search when decentralized discovery is the better fit
- keep shared files intentional, especially when publishing rare files
- remember that queue behavior and seeding policy are local controls, not protocol changes

Controller tools should preserve these native distinctions instead of flattening
everything into a generic download-client model.

## REST And Local Controllers

The REST API is for trusted local controllers and companion tools. It is exposed
from the existing WebServer listener and uses an authenticated JSON `/api/v1`
contract.

Operational guidance:

- bind the WebServer/REST listener deliberately
- use `X-API-Key`
- keep the surface on trusted networks or behind trusted local controls
- prefer controllers that respect eMule's native search, transfer, and delete semantics
- treat aMuTorrent and Arr flows as adapters around native behavior, not as the authority for the native route shape

References:

- [REST API contract](../rest/REST-API-CONTRACT.md)
- [OpenAPI contract](../rest/REST-API-OPENAPI.yaml)
- [REST parity inventory](../rest/REST-API-PARITY-INVENTORY.md)

## Release Status And Validation

eMule BB is under active pre-release development. Release readiness is tracked
in the active docs, with gates for native tests, REST contract behavior,
malformed request coverage, UI automation, live eD2K/Kad scenarios, and
aMuTorrent/Arr validation.

Before treating a build as release-quality, check:

- [Beta 0.7.3 dashboard](../active/RELEASE-0.7.3.md)
- [Beta 0.7.3 checklist](../active/RELEASE-0.7.3-CHECKLIST.md)
- [Beta 0.7.3 runbook](../active/RELEASE-0.7.3-RUNBOOK.md)
- [Active backlog index](../active/INDEX.md)

## Troubleshooting Pointers

When behavior is surprising, narrow the problem before changing many settings:

- connection issues: verify bind settings, firewall rules, server state, and Kad bootstrap
- slow upload: confirm the configured upload limit, target slot count, and whether slots are actually weak or only warming up
- large-library sluggishness: check long-path support, share-root size, startup cache state, and directory churn
- REST failures: verify API key, route shape, JSON field names, bind address, and allowed network path
- controller mismatches: compare controller assumptions against the native REST contract

Keep changes small and observable. eMule BB's product direction favors behavior
that can be tested, explained, and validated.

## Public Documentation Map

- [Documentation index](../INDEX.md)
- [Workspace policy](../WORKSPACE_POLICY.md)
- [Documentation policy](../DOCS_POLICY.md)
- [Broadband feature notes](FEATURE-BROADBAND.md)
- [REST API contract](../rest/REST-API-CONTRACT.md)
- [Beta 0.7.3 status](../active/RELEASE-0.7.3.md)
