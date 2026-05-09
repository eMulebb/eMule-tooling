# R-1.0.1 Legacy And Frozen Feature Disposition

- Date: 2026-05-09
- Gate: [REF-037](../items/REF-037.md)
- Baseline: `release/v0.72a-community`
- Candidate app commit: `11e5966`

## Finding

REF-037 found one release-impacting cleanup gap: MiniMule runtime files had
already been intentionally removed, but dead MiniMule resource IDs, a stub
dialog, translated `IDS_ENABLEMINIMULE` strings, and a missing `eMule Light`
project item still remained. Those dangling surfaces were removed in app commit
`11e5966` (`REF-037 remove stale MiniMule resource surface`).

No `BUG-111+` item is required. The remaining legacy areas are either supported
and covered by CI-030 smoke evidence, intentionally removed by an existing item,
or explicitly frozen by product decision.

## Disposition Ledger

| Feature area | CI-022 paths | R-1.0.1 disposition | Evidence |
|--------------|--------------|---------------------|----------|
| MiniMule runtime and IE host | `MiniMule.cpp/.h`, `IESecurity.cpp/.h`, `res/MiniMule.htm`, `res/MiniMuleBack.gif` | Intentionally removed | [REF-025](../items/REF-025.md); app `867d303`; stale resource cleanup app `11e5966` |
| MiniMule resource leftovers | `IDD_MINIMULE`, `IDR_HTML_MINIMULE`, `IDS_ENABLEMINIMULE`, translated `IDS_ENABLEMINIMULE` rows | Restored before release by deletion of stale surface | app `11e5966`; `rg` no longer finds MiniMule/Light identifiers under `srchybrid` |
| WinServ firewall opener | `FirewallOpener.cpp/.h`, `UPnPImplWinServ.cpp/.h` | Intentionally removed from active NAT mapping path | [FEAT-032](../items/FEAT-032.md); [CI-029](../items/CI-029.md) |
| Import Parts / old part conversion | `ImportParts.h`, `PartFileConvert.cpp/.h` | Intentionally removed | [FEAT-033](../items/FEAT-033.md); [CI-027](../items/CI-027.md) |
| Secondary run-as-user helper | `SecRunAsUser.cpp/.h` | Intentionally removed with MiniMule/IE-era helper cleanup | [REF-025](../items/REF-025.md); [REF-033](../items/REF-033.md) |
| Legacy web light template | `webinterface/eMule Light.tmpl` and stale project `..\setup\eMule Light.tmpl` item | Intentionally removed; stale project item deleted | app `11e5966`; [CI-025](../items/CI-025.md) covers current WebServer/template contracts |
| IRC client and IRC preferences | `IrcMain`, `IrcWnd`, IRC list controls, `PPgIRC` | Supported for R-1.0.1, not removed in this release | [CI-030](../items/CI-030.md) UI/preference smoke; [REF-025](../items/REF-025.md) keeps broader removal as future scope |
| Scheduler | `Scheduler.cpp`, `PPgScheduler.cpp/.h` | Supported for R-1.0.1, not removed in this release | [CI-030](../items/CI-030.md); scheduler remains live in app build |
| SMTP notifications | `SendMail.cpp`, `SMTPdialog.cpp/.h`, notify preferences | Supported for R-1.0.1, not removed in this release | [CI-030](../items/CI-030.md); [REF-025](../items/REF-025.md) keeps broader removal as future scope |
| First-start wizard | `Wizard.cpp/.h` and wizard resources | Supported/frozen for R-1.0.1; no further removal in patch scope | [CI-030](../items/CI-030.md); [REF-025](../items/REF-025.md) tracks future removal |
| Splash screen | `SplashScreen.cpp/.h` and preference surface | Supported/frozen for R-1.0.1; no further removal in patch scope | [CI-030](../items/CI-030.md); [REF-025](../items/REF-025.md) tracks future removal |
| Update check | `ReleaseUpdateCheck*`, version-check UI paths | Supported for R-1.0.1 | [CI-030](../items/CI-030.md); [CI-031](../items/CI-031.md) package/release docs |
| Archive preview/recovery | `ArchivePreviewDlg.cpp`, `ArchiveRecovery.cpp` | Intentionally frozen with known bugs accepted | [BUG-074](../items/BUG-074.md); [BUG-098](../items/BUG-098.md) |
| Win32 manifest/build artifacts | `srchybrid/res/emuleWin32.manifest` and packaging outputs | Intentionally removed from supported R-1.0.1 package surface | [CI-031](../items/CI-031.md); x64/ARM64 package scans exclude Win32/x86/project/debug artifacts |
| Language/resource command IDs | language DLL projects and resource IDs affected by removed MiniMule resources | Restored before release by aligning active resources with removed runtime surface | app `11e5966`; x64 and ARM64 package language builds passed |

## Validation Evidence

- Search audit:

  ```powershell
  rg -n "IDR_HTML_MINIMULE|IDD_MINIMULE|IDS_ENABLEMINIMULE|MiniMule|IESecurity|eMule Light" srchybrid -S
  ```

  Result: no matches.

- App build:

  ```powershell
  pwsh -NoLogo -NoProfile -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform x64
  pwsh -NoLogo -NoProfile -File repos\eMule-build\workspace.ps1 build-app -Config Release -Platform ARM64
  ```

  Results: x64 passed in
  `workspaces\v0.72a\state\build-logs\20260509-160748`; ARM64 passed in
  `workspaces\v0.72a\state\build-logs\20260509-160940`.

- Package rehearsal after app commit `11e5966`:

  ```powershell
  pwsh -NoLogo -NoProfile -File repos\eMule-build\workspace.ps1 package-release -Config Release -Platform x64
  pwsh -NoLogo -NoProfile -File repos\eMule-build\workspace.ps1 package-release -Config Release -Platform ARM64
  ```

  Results:

  | Platform | Package SHA256 | Manifest app commit |
  |----------|----------------|---------------------|
  | x64 | `13a0f7c676cb2889734d83a3b181f71be0f316c4bdfad2aa73845e000ea31202` | `11e5966` |
  | ARM64 | `653ab15fcc743d538da8ad10198324fdd19adc92f6ce3aa45de465c4c40c2c10` | `11e5966` |

## Release Decision

REF-037 is closed for R-1.0.1. The remaining broad legacy-removal work stays in
[REF-025](../items/REF-025.md) and [REF-033](../items/REF-033.md) as post-release
scope unless a future audit proves an active regression.
