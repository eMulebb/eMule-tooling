---
id: FEAT-042
title: Automatic IP filter update scheduling
status: Open
priority: Minor
category: feature
labels: [ipfilter, security, automation, preferences, emuleai]
milestone: ~
created: 2026-04-25
source: `analysis\emuleai` v1.4 release notes
---

## Summary

Add an optional scheduler for updating `ipfilter.dat` from a configured URL
using the already-hardened safe download and promotion path.

## Intended Mainline Shape

- reuse the existing manual IP-filter update implementation
- add an explicit auto-update toggle
- add a configurable update interval in days
- log success, no-change, and failure states clearly
- avoid deleting or replacing the live filter if download or validation fails

## Acceptance Criteria

- [ ] automatic updates are disabled by default
- [ ] the interval is persisted and validated
- [ ] the manual update path and automatic path share the same safe promotion
      logic
- [ ] invalid downloads preserve the previous live `ipfilter.dat`
