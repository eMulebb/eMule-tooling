# Release 1.0 NAT Mapping Execution Plan

This is the active execution plan for NAT mapping modernization. It does not
own gate status; use [RELEASE-1.0](RELEASE-1.0.md) for release decisions and
[FEAT-032](FEAT-032.md) for item state and evidence.

Current status: NAT mapping is a Release 1 candidate, not a blocker. The
code/build slice can be accepted for Release 1 if current validation passes,
but the tag must not be blocked solely because the available network cannot
prove a PCP/NAT-PMP-capable path.

## Decisions

- Keep MiniUPnP as the `UPnP IGD` backend.
- Remove the legacy Windows-service/COM UPnP backend from active runtime
  behavior.
- Add `libpcpnatpmp` as the PCP/NAT-PMP backend.
- Keep the top-level mapping controls: `EnableUPnP`, `WebUseUPnP`, and
  `CloseUPnPOnExit`.
- Keep mapping scope to main TCP, main UDP, and WebServer TCP when
  `WebUseUPnP` is enabled.
- In `Automatic`, try `UPnP IGD (MiniUPnP)` first, then `PCP/NAT-PMP`.

## Runtime Shape

The Release 1 candidate shape is:

- `Automatic`: MiniUPnP first, PCP/NAT-PMP fallback
- `UPnP IGD only`: MiniUPnP only
- `PCP/NAT-PMP only`: PCP/NAT-PMP only

WinServ-only preferences and remembered implementation state must not control
current runtime behavior.

## Validation Path

Required local proof:

```powershell
pwsh -File repos\eMule-build\workspace.ps1 validate
pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Debug -Platform x64
pwsh -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64
```

Required targeted proof:

- native or seam coverage locks `Automatic` ordering
- app build links `libpcpnatpmp` through the supported workspace path
- Tweaks exposes the three backend modes
- removed WinServ-only active preferences do not affect runtime mapping

Live-network proof, when available:

- MiniUPnP success path
- PCP/NAT-PMP fallback path
- explicit `PCP/NAT-PMP only` mode
- WebServer TCP mapping when `WebUseUPnP` is enabled

## Release 1 Decision Rule

Mark [FEAT-032](FEAT-032.md) complete only after the code/build slice is landed
and live-network validation is recorded. If the local network cannot provide
PCP/NAT-PMP proof, keep the item deferred for Release 1 and record the external
condition instead of delaying the release tag.
