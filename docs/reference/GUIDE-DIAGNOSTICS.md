# Diagnostics Guide

This guide covers the diagnostics surfaces available to users and operators.

## Diagnostic Philosophy

Collect evidence before changing many settings. eMule BB includes diagnostics
for startup, network, IO, sharing, REST, and process state so problems can be
narrowed without guessing.

## Logs

Tools menu diagnostics can open:

- normal eMule log
- verbose log

Use the normal log for user-facing events and the verbose log for deeper
runtime detail. When reporting an issue, include the recent log lines around
the failure, not only the final symptom.

## Diagnostic Snapshot JSON

Tools can copy diagnostic snapshot JSON to the clipboard. Two variants exist:

- raw snapshot
- redacted snapshot

Use redacted snapshots for sharing unless exact addresses, paths, command line,
or firewall repair output are needed privately.

The snapshot includes:

- app version and product identity
- system CPU/memory summary
- process IDs, thread ID, uptime, process CPU time
- important paths
- network state, ports, binding, adapters, sockets
- eD2K and Kad status
- Windows Firewall desired rules and last repair result
- shared startup cache state
- IO and socket buffer state
- transfer rates and counts
- loaded modules

## Dumps

Tools can capture:

- mini dump
- full memory dump

Mini dumps are smaller and usually enough for crash triage. Full memory dumps
are larger and useful for deep hangs, memory growth, or difficult release-build
diagnosis. Treat full dumps as private data.

## Firewall Repair Evidence

The Windows Firewall repair action launches an elevated PowerShell script. The
script shows the program path, scope, rules, and result in its own window. The
last repair result is also included in diagnostic snapshots.

Use this evidence to distinguish:

- repair not launched
- user cancelled UAC
- exact-name rules replaced
- rule creation failed
- repair succeeded but router/NAT remains wrong

## Startup And Large Library Evidence

For large shared libraries, the snapshot includes shared startup cache state:

- cache available/ready
- records loaded
- cache reject code
- directories scanned
- duplicate path cache state
- hash queue count
- deferred hashing status
- save progress

Use this before deleting caches or assuming startup is stuck.

## IO And Performance Evidence

IO diagnostics include:

- automatic broadband IO setting
- configured and effective file buffer size
- buffered download bytes/count
- upload timer duration and slow-loop count
- UDP receive buffer target/actual
- active TCP upload socket buffer samples

This helps separate network throughput problems from disk/loop pressure.

## REST Diagnostics

REST failures should be diagnosed with:

- app lifecycle state
- API key configuration
- listener bind and port
- allowed IP/network path
- route and JSON field shape
- recent REST errors/logs
- current OpenAPI contract

Use [Controllers and REST Guide](GUIDE-CONTROLLERS-REST.md) and
[REST API Contract](../rest/REST-API-CONTRACT.md).

## Privacy

Diagnostic data can contain:

- public IPs
- local IPs
- paths with usernames
- command lines
- loaded module paths
- controller endpoints

Share redacted snapshots by default. Share raw data only in trusted private
contexts where exact values are required.
