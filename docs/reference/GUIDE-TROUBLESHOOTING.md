# Troubleshooting Guide

This guide starts from symptoms and points to the smallest useful checks.

## Low ID

Likely areas:

- TCP port blocked by Windows Firewall
- router/NAT forwarding missing
- UPnP failed
- bind interface/address mismatch
- VPN path not forwarding inbound traffic
- wrong public path after network change

Check:

1. Connection page TCP/UDP ports.
2. Tools > Check Open Ports.
3. Tools > Repair Windows Firewall Rules.
4. Bind status in the UI and diagnostic snapshot.
5. Router forwarding or VPN forwarding policy.
6. Current eD2K server status.

## Kad Firewalled

Likely areas:

- UDP blocked
- Kad not fully bootstrapped
- UDP firewall test still running or stale
- wrong bind target
- router/NAT not forwarding UDP

Check:

1. Kad connected/running state.
2. UDP port and listen socket in diagnostics.
3. Kad firewall recheck.
4. UPnP/router status.
5. Firewall repair result.
6. Fresh `nodes.dat` bootstrap if Kad has no useful contacts.

## No Search Results

Likely areas:

- not connected to the selected search network
- stale or poor server list
- Kad not bootstrapped
- search method mismatch
- over-specific query
- controller mapping to the wrong search type

Check:

1. Server/Kad status.
2. Try a simpler query.
3. Try a different search method.
4. Update server.met from trusted sources.
5. Bootstrap Kad.
6. Compare controller search request against native REST search tokens.

## Slow Startup With Large Libraries

Likely areas:

- first scan after adding large roots
- startup cache missing or rejected
- duplicate path cache missing or rejected
- long-path or inaccessible directory churn
- hash worker still processing
- monitor-owned shares changed since last run

Check:

1. Diagnostic snapshot shared startup cache section.
2. Shared Files page hash/scanning state.
3. Long path setup.
4. Share roots for accidental broad directories.
5. `shareignore.dat` rules.
6. Whether startup cache sidecars were deleted.

## Slow Upload Or Weak Slots

Likely areas:

- upload limit too high or unlimited
- too many upload clients for the line
- slow upload detection warming up
- disk or timer loop pressure
- remote clients are slow

Check:

1. Finite upload limit.
2. max upload clients setting.
3. upload ratio/slot columns.
4. diagnostic IO section and upload timer stats.
5. active upload socket buffer samples.
6. recent logs for repeated slow-loop or disk pressure.

## REST Fails

Likely areas:

- REST/WebServer disabled
- wrong bind address or port
- wrong API key
- request sent during startup/shutdown
- route or JSON shape not in OpenAPI
- legacy template assumption instead of REST

Check:

1. WebServer/REST preferences.
2. API key header.
3. `/api/v1/app` status.
4. app lifecycle state.
5. OpenAPI route and schema.
6. recent logs.
7. redacted diagnostic snapshot.

## Downloads Renamed Poorly

Likely areas:

- weak source-name majority
- fake-file cleanup rule too aggressive
- result set contains generic names
- extension mismatch

Check:

1. File details and source names.
2. fake/trust feedback.
3. comments.
4. original ED2K link/name.
5. category and destination.

Avoid batch cleanup until the selected rows are trustworthy.

## IP Filter Seems Ineffective

Likely areas:

- `ipfilter.dat` exists but filtering is disabled
- file was edited but not reloaded
- update URL failed
- filter level excludes expected ranges
- server filtering not enabled when testing server IPs

Check:

1. `Preferences > Security > IP Filter` checkbox.
2. loaded rule count and filter level.
3. Tools > Reload IP Filter.
4. update URL and update log.
5. [IP Filter Guide](GUIDE-IP-FILTERS.md).

## Collecting Evidence

Before reporting or changing many settings:

1. Copy a redacted diagnostic snapshot.
2. Save recent log lines.
3. Note exact action and time.
4. Include current connection state.
5. Include whether the profile is new, upgraded, or large-library.
