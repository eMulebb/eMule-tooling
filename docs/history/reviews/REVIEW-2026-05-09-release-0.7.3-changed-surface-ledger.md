# Beta 0.7.3 Changed-Surface Ledger

- Date: 2026-05-09
- Baseline: `release/v0.72a-community`
- Candidate: `EMULE_WORKSPACE_ROOT\workspaces\v0.72a\app\eMule-main` on `main`
- Command: `git diff --name-status release/v0.72a-community...main -- . ':!srchybrid/emule.vcxproj.filters' ':!srchybrid/emule.vcxproj.user'`
- Total changed paths: `759`
- Removed or renamed paths: `30`

## Completion Rule

Every path below is assigned to exactly one Beta 0.7.3 audit area. The
owning item is responsible for converting the row into passing evidence, a
new bug, an explicit Wont-Fix/product decision, or a non-blocking
improvement. This ledger intentionally does not close the downstream gates;
it prevents changed paths from escaping review.

## Area Summary

| Area | Paths | Owner item |
|------|-------|------------|
| Build/package/resources/languages | `108` | [CI-031](../items/CI-031.md) |
| Downloads/part files/persistence | `47` | [CI-027](../items/CI-027.md) |
| GeoLocation/IPFilter/data refresh | `262` | [CI-029](../items/CI-029.md) |
| Legacy/frozen feature disposition | `31` | [REF-037](../items/REF-037.md) |
| Networking/UDP/sockets/UPnP | `49` | [CI-029](../items/CI-029.md) |
| Preferences/config/UI shell | `133` | [CI-030](../items/CI-030.md) |
| REST/WebServer/Arr/qBit/WebSocket | `24` | [CI-025](../items/CI-025.md) |
| Search/server/Kad | `63` | [CI-028](../items/CI-028.md) |
| Shared files/startup cache/long path | `29` | [CI-026](../items/CI-026.md) |
| Upload queue/bandwidth | `13` | [CI-028](../items/CI-028.md) |

## Ledger

### Build/package/resources/languages

Owner: [CI-031](../items/CI-031.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `.editorconfig` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `.gitattributes` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `A` | `.github/workflows/baseline.yml` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `A` | `.gitignore` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `A` | `AGENTS.md` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `A` | `manifests/privacy-guard/policy.v1.json` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `A` | `README.md` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/emule_site_config.h` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/emule.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `D` | `srchybrid/emule.sln` | Partial: packaging/build parity, not runtime branch equivalence | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `D` | `srchybrid/emule.slnx` | Partial: packaging/build parity, not runtime branch equivalence | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/emule.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ar_AE.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ar_AE.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ba_BA.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ba_BA.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/bg_BG.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/bg_BG.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ca_ES.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ca_ES.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/cz_CZ.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/cz_CZ.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/da_DK.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/da_DK.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/de_DE.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/de_DE.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/el_GR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/el_GR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/es_AS.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/es_AS.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/es_ES_T.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/es_ES_T.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/et_EE.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/et_EE.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fa_IR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fa_IR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fi_FI.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fi_FI.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fr_BR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fr_BR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fr_FR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/fr_FR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/gl_ES.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/gl_ES.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/he_IL.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/he_IL.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/hu_HU.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/hu_HU.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/it_IT.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/it_IT.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/jp_JP.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/jp_JP.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ko_KR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ko_KR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lang.sln` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lang.slnx` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lt_LT.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lt_LT.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lv_LV.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/lv_LV.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/mt_MT.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/mt_MT.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nb_NO.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nb_NO.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nl_NL.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nl_NL.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nn_NO.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/nn_NO.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pl_PL.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pl_PL.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pt_BR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pt_BR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pt_PT.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/pt_PT.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ro_RO.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ro_RO.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ru_RU.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ru_RU.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sl_SI.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sl_SI.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sq_AL.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sq_AL.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sv_SE.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/sv_SE.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/tr_TR.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/tr_TR.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ua_UA.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ua_UA.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ug_CN.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/ug_CN.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/va_ES_RACV.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/va_ES_RACV.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/va_ES.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/va_ES.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/vi_VN.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/vi_VN.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/zh_CN.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/zh_CN.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/zh_TW.rc` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/lang/zh_TW.vcxproj` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `D` | `srchybrid/res/ContentDB.ico` | Partial: packaging/build parity, not runtime branch equivalence | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/res/emule.rc2` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/res/emuleARM64.manifest` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `D` | `srchybrid/res/emuleWin32.manifest` | Partial: packaging/build parity, not runtime branch equivalence | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/res/emulex64.manifest` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/Resource.h` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/StringConversion.h` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |
| `M` | `srchybrid/Version.h` | Partial: packaging/build parity, not runtime branch equivalence | Validate packaging/build/resource impact in CI-031 |

### Downloads/part files/persistence

Owner: [CI-027](../items/CI-027.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/3DPreviewControl.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/Collection.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/Collection.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/CollectionCreateDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/CollectionFile.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/CollectionListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/CollectionSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DeadSourceList.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DeadSourceList.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/DirectDownload.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/DirectDownload.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DirectDownloadDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadClient.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadClientsCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadClientsCtrl.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/DownloadProgressBarSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadQueue.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/DownloadQueue.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/DownloadQueueDiskSpaceSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/DownloadQueueOverviewSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/FileCompletionCommandSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/FileDetailDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/FileDetailDialogName.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/FileDetailDlgStatistics.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/FileInfoDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/GZipFile.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/HttpDownloadDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/HttpDownloadDlg.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/MediaInfo_DLL.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/MediaInfo.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/MediaInfo.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/MetaDataDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/PartFile.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/PartFile.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/PartFileCompletionSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/PartFileHashSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/PartFileMajorityNameSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/PartFilePauseResumeSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/PartFilePersistenceSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `A` | `srchybrid/PartFilePreviewSeams.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/PartFileWriteThread.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/PartFileWriteThread.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/Preview.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/SafeFile.h` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |
| `M` | `srchybrid/ZIPFile.cpp` | Yes where the behavior still exists in eMule BB | Replay download/persistence gate in CI-027 |

### GeoLocation/IPFilter/data refresh

Owner: [CI-029](../items/CI-029.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `A` | `srchybrid/GeoLocation.cpp` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/GeoLocation.h` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `M` | `srchybrid/IPFilter.cpp` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `M` | `srchybrid/IPFilterDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/IPFilterSeams.h` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/IPFilterUpdater.cpp` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/IPFilterUpdater.h` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/IPFilterUpdateSeams.h` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/a1.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/a2.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ad.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ae.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/af.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ag.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ai.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/al.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/am.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ao.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/aq.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ar.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/as.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/at.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/au.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/aw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ax.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/az.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ba.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bb.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bd.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/be.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bi.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bj.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bo.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bq.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/br.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bs.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/by.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/bz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ca.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cd.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ch.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ci.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ck.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/co.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cx.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cy.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/cz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/de.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/dj.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/dk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/dm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/do.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/dz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ec.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ee.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/eg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/eh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/er.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/es.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/et.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/eu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fi.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fj.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fo.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/fr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ga.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gb.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gd.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ge.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gi.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gp.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gq.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gs.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/gy.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/hk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/hm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/hn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/hr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ht.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/hu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/id.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ie.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/il.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/im.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/in.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/io.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/iq.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ir.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/is.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/it.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/je.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/jm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/jo.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/jp.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ke.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ki.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/km.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kp.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ky.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/kz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/la.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lb.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/li.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ls.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/lv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ly.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ma.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/md.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/me.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ml.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mo.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mp.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mq.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ms.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mx.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/my.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/mz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/na.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ne.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ng.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ni.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/no.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/not.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/np.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/nz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/om.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pa.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pe.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ph.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ps.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/pw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/py.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/qa.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/re.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ro.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/rs.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ru.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/rw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sa.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sb.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sd.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/se.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sh.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/si.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sj.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/so.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ss.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/st.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sx.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sy.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/sz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/td.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/th.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tj.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tl.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/to.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tr.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tv.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/tz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ua.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ug.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/um.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/us.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/uy.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/uz.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/va.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/vc.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ve.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/vg.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/vi.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/vn.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/vu.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/wf.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ws.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/xk.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/ye.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/yt.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/za.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/zm.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |
| `A` | `srchybrid/res/Flags/zw.ico` | Yes where the behavior still exists in eMule BB | Replay data refresh and resource impact in CI-029/CI-031 |

### Legacy/frozen feature disposition

Owner: [REF-037](../items/REF-037.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/ArchivePreviewDlg.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ArchiveRecovery.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/FirewallOpener.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/FirewallOpener.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/IESecurity.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/IESecurity.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/ImportParts.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `M` | `srchybrid/IrcChannelListCtrl.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/IrcChannelTabCtrl.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/IrcMain.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/IrcMain.h` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/IrcNickListCtrl.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/IrcWnd.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/MiniMule.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/MiniMule.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/PartFileConvert.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/PartFileConvert.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `M` | `srchybrid/PPgIRC.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgIRC.h` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgScheduler.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgScheduler.h` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/res/MiniMule.htm` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/res/MiniMuleBack.gif` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `M` | `srchybrid/Scheduler.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/SecRunAsUser.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/SecRunAsUser.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `M` | `srchybrid/SendMail.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/UPnPImplWinServ.cpp` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/UPnPImplWinServ.h` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `D` | `srchybrid/webinterface/eMule Light.tmpl` | Yes: stock behavior must be dispositioned explicitly | Removed/frozen path; classify in REF-037 before release |
| `M` | `srchybrid/Wizard.cpp` | Yes: stock behavior must be dispositioned explicitly | Replay UI/preferences/language smoke gate in CI-030 |

### Networking/UDP/sockets/UPnP

Owner: [CI-029](../items/CI-029.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/AsyncProxySocketLayer.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/AsyncSocketEx.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/AsyncSocketEx.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/AsyncSocketExRuntimeSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/BaseClient.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/BaseClientFriendBuddySeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/BindAddressResolver.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/BindAddressResolver.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/BindStartupPolicy.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ClientCredits.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ClientCredits.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ClientCreditsSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ClientUDPSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ClientUDPSocket.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/ClientUDPSocketSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/CreditsThread.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/EMSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/EncryptedDatagramSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/EncryptedStreamSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/EncryptedStreamSocket.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Friend.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Friend.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/FriendList.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/FriendList.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ListenSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/ListenSocket.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Mdump.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Mdump.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/NetworkInfoDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Packets.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/PerfLog.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/PerfLog.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/PerfLogSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Pinger.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/Pinger.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/PPgProxy.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/PPgProxy.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UDPSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UDPSocket.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/UDPSocketSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UPnPImpl.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UPnPImplMiniLib.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UPnPImplMiniLib.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/UPnPImplPcpNatPmp.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/UPnPImplPcpNatPmp.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UPnPImplWrapper.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/UPnPImplWrapper.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `A` | `srchybrid/UPnPImplWrapperSeams.h` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |
| `M` | `srchybrid/URLClient.cpp` | Yes where the behavior still exists in eMule BB | Replay network adversity gate in CI-029 |

### Preferences/config/UI shell

Owner: [CI-030](../items/CI-030.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/AbstractFile.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/AICHSyncThread.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/AICHSyncThread.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/AppKeyboardShortcutsSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/BuddyButton.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ButtonsTabCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/CaptchaGenerator.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/CatDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ChatSelector.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ChatWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClientDetailDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClientList.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClientList.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClientListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClientListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClosableTabCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ClosableTabCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/CustomAutoComplete.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/DialogMinTrayBtn.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/DialogMinTrayBtn.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/DisplayRefreshSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/dxtrans.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/EditDelayed.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Emule.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Emule.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/EmuleDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/EmuleDlg.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `R098` | `srchybrid/MD4.cpp` -> `srchybrid/EmuleMD4.cpp` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `R094` | `srchybrid/MD4.h` -> `srchybrid/EmuleMD4.h` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `R099` | `srchybrid/SHA.cpp` -> `srchybrid/EmuleSHA.cpp` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `R099` | `srchybrid/SHA.h` -> `srchybrid/EmuleSHA.h` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/EnBitmap.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/FileBufferSlider.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/FileIdentifier.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/FrameGrabThread.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/HelperThreadLaunchSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/HighColorTab.hpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/HTRichEditCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/HTRichEditCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/I18n.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/I18nSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Ini2.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Ini2.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/Ini2Helpers.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/LastCommonRouteFinder.cpp` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `D` | `srchybrid/LastCommonRouteFinder.h` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/ListCtrlItemWalk.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ListCtrlX.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ListViewWalkerPropertySheet.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/LockScopeSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Log.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Log.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/LogFileSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MD5Sum.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MenuCmds.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MeterIcon.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleStatusBarCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleStatusBarCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleSystrayDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/MuleToolBarCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Opcodes.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/OtherFunctions.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/OtherFunctions.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/OtherFunctionsSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Parser.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Parser.hpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgConnection.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgConnection.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgDirectories.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgDirectories.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgDisplay.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgDisplay.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgFiles.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgFiles.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgGeneral.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgGeneral.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgMessages.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgMessages.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgNotify.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgNotify.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgSecurity.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgSecurity.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgStats.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgStats.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgTweaks.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PPgTweaks.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/PreferenceIniMap.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Preferences.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Preferences.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PreferencesDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/PreferencesDlg.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/PreferenceToolTipHelper.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/PreferenceUiSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ProgressCtrlX.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/ProUserMenuCopySeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/ReleaseUpdateCheck.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/ReleaseUpdateCheck.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/ReleaseUpdateCheckSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Ring.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/SelfTest.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/SHAHashSet.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/SmileySelector.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/SplashScreen.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/StartupConfigOverride.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Statistics.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Statistics.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/StatisticsDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/StatisticsTree.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/StatusBarInfo.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/Stdafx.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/StringConversion.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TabCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TaskbarNotifier.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TitledMenu.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ToolbarWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/ToolTipCtrlX.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TransferDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TransferWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `A` | `srchybrid/TransferWndSeams.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TrayDialog.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TrayDialog.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TreeOptionsCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TreeOptionsCtrl.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TreeOptionsCtrlEx.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TreePropSheet.cpp` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/TreePropSheetPgFrameDef.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/types.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/UpdownClient.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `M` | `srchybrid/UserMsgs.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |
| `D` | `srchybrid/WidePathFileSeams.h` | Yes where the behavior still exists in eMule BB | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `A` | `srchybrid/WinInetHandle.h` | Yes where the behavior still exists in eMule BB | Replay UI/preferences/language smoke gate in CI-030 |

### REST/WebServer/Arr/qBit/WebSocket

Owner: [CI-025](../items/CI-025.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/PPgWebServer.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `M` | `srchybrid/PPgWebServer.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `R056` | `srchybrid/PipeApiCommandSeams.h` -> `srchybrid/WebApiCommandSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `R057` | `srchybrid/PipeApiSurfaceSeams.h` -> `srchybrid/WebApiSurfaceSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Removed/renamed path; verify owner item covers compatibility or packaging impact |
| `M` | `srchybrid/WebServer.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `M` | `srchybrid/WebServer.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerArrCompat.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerArrCompat.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerArrCompatSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerAuthStateSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerJson.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerJson.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerJsonSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerLegacySeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerQBitCompat.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerQBitCompat.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerQBitCompatSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebServerStaticFileSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `M` | `srchybrid/WebSocket.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `M` | `srchybrid/WebSocket.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebSocketHttpSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WebSocketTlsSeams.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `A` | `srchybrid/WindowsToastNotifier.cpp` | Partial: native REST/adapter additions plus legacy WebServer parity | Replay REST/adapter/WebServer contract in CI-025 |
| `R055` | `mbedtls/tf-psa-crypto/include/mbedtls/threading_alt.h` -> `srchybrid/WindowsToastNotifier.h` | Partial: native REST/adapter additions plus legacy WebServer parity | Removed/renamed path; verify owner item covers compatibility or packaging impact |

### Search/server/Kad

Owner: [CI-028](../items/CI-028.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/KadContactListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KadContactListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/io/BufferedFileIO.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/io/DataIO.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Entry.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Entry.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Indexed.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Kademlia.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Kademlia.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Prefs.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Search.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/Search.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/SearchManager.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/SearchManager.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/UDPFirewallTester.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/kademlia/UDPFirewallTester.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/net/KademliaUDPListener.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/net/KademliaUDPListener.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/net/PacketTracking.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/net/PacketTracking.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/routing/RoutingBin.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/routing/RoutingBin.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/routing/RoutingZone.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/routing/RoutingZone.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/FastKad.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/FastKad.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/KadPersistenceSeams.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/KadSupport.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/utils/LookupHistory.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/utils/LookupHistory.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/NodesDatSupport.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/kademlia/utils/NodesDatSupport.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/kademlia/utils/UInt128.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KademliaWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KademliaWnd.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KadLookupGraph.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KadSearchListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/KadSearchListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/PPgServer.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/PPgServer.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchDlg.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchList.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchList.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchParams.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchParamsPolicy.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchParamsWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchParamsWnd.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchResultsWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/SearchResultsWnd.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/Server.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerConnect.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerConnect.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerList.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerList.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerListCtrl.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/ServerMetPersistenceSeams.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerSocket.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerSocket.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/ServerSocketSeams.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/ServerWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/SourceExchangeSeams.h` | Yes where the behavior still exists in eMule BB | Replay search/server/Kad parity gate in CI-028 |

### Shared files/startup cache/long path

Owner: [CI-026](../items/CI-026.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/DirectoryTreeCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/DirectoryTreeCtrl.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/FilenameNormalizationPolicy.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFile.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFile.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFileList.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFileList.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFileListSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/KnownFileLookupIndex.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/KnownFileMetadataSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/KnownFileProgressSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/LongPathSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/PathHelpers.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/ShareableFile.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/SharedDirectoryOps.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedDirsTreeCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedDirsTreeCtrl.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/SharedDuplicatePathCachePolicy.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/SharedFileIntakePolicy.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFileList.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFileList.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFileListSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFilesCtrl.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFilesCtrl.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFilesWnd.cpp` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `M` | `srchybrid/SharedFilesWnd.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/SharedFilesWndSeams.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/SharedStartupCachePolicy.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |
| `A` | `srchybrid/ShellUiHelpers.h` | Yes where the behavior still exists in eMule BB | Replay shared-file/startup/long-path gate in CI-026 |

### Upload queue/bandwidth

Owner: [CI-028](../items/CI-028.md)

| Status | Path | Baseline comparison | Disposition |
|--------|------|---------------------|-------------|
| `M` | `srchybrid/QueueListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/QueueListCtrl.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadBandwidthThrottler.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadBandwidthThrottler.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadClient.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadDiskIOThread.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadDiskIOThread.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadListCtrl.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadListCtrl.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadQueue.cpp` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadQueue.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `M` | `srchybrid/UploadQueueSeams.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
| `A` | `srchybrid/UploadScoreSeams.h` | Yes where the behavior still exists in eMule BB | Review with search/server/Kad parity gate in CI-028 |
