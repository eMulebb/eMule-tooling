# Preference Surface Matrix

This is the canonical exact active preference matrix for current `main`. It
owns active preference keys, sections, defaults, persisted normalization, UI
validation, and REST exposure.

Architecture, compatibility policy, retired names, and non-preference INI state
summaries live in [`ARCH-PREFERENCES.md`](ARCH-PREFERENCES.md).

`None` in the REST column means the setting is not part of
`GET /api/v1/app/preferences` or `PATCH /api/v1/app/preferences`. WebServer
HTML form fields are separate from that REST preference surface.

## UI Preference Matrix

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `Nick` | `eMule` | `DEFAULT_NICK` | Empty/default nick normalizes to `DEFAULT_NICK`. | General page text field. | None |
| `Language` | `eMule` | `0` | Stored as a `WORD`; `0` means normal app/default language selection. | General page combo reloads UI on change. | None |
| `BringToFront` | `eMule` | `false` | Boolean. | General page checkbox. | None |
| `OnlineSignature` | `eMule` | `false` | Boolean. | General page checkbox. | None |
| `StartupMinimized` | `eMule` | `false` | Boolean. | General page checkbox. | None |
| `AutoStart` | `eMule` | `false` | Boolean plus Windows startup registration. | General page checkbox. | None |
| `PreventStandby` | `eMule` | `false` | Boolean; runtime effect depends on OS power API support. | General page checkbox. | None |
| `MaxUpload` | `eMule` | `6100` KiB/s | `0` or `>= UINT32_MAX` normalizes to branch default; setters keep finite values. | Connection page numeric field. | `uploadLimitKiBps`, PATCH `1..4294967294` |
| `MaxDownload` | `eMule` | `12207` KiB/s | Setter maps `0` to `1`; REST rejects unlimited sentinel. | Connection page numeric field. | `downloadLimitKiBps`, PATCH `1..4294967294` |
| `MaxConnections` | `eMule` | `GetRecommendedMaxConnections()` | Positive-or-default; computed default is normally `500` on modern unlimited/high TCP caps. | Connection page numeric field. | `maxConnections`, PATCH `1..2147483647` |
| `MaxHalfConnections` | `eMule` | `50` | Positive-or-default. | Tweaks advanced tree numeric field. | None |
| `MaxConnectionsPerFiveSeconds` | `eMule` | `50` | Positive-or-default; setter path now normalizes consistently. | Tweaks advanced tree numeric field rejects `0`. | `maxConnectionsPerFiveSeconds`, PATCH `1..2147483647` |
| `Port` | `eMule` | random TCP port | Missing/invalid direct INI value becomes a random valid port. | Connection page validates port. | None |
| `UDPPort` | `eMule` | random UDP port | Missing key becomes random; `0` disables UDP; invalid direct value becomes random. | Connection page validates port or `0`. | None |
| `ServerUDPPort` | `eMule` | random/back-compatible sentinel | `0` disables server UDP; invalid direct value normalizes. | Connection page validates port or `0`. | None |
| `BindInterface` | `eMule` | empty string | Trimmed; startup bind block is enabled only when the interface value is non-empty. | Connection page selector/text. | None |
| `BindAddr` | `eMule` | empty string | Trimmed IPv4/address override; empty means all applicable addresses. | Connection page validates address entry. | None |
| `BlockNetworkWhenBindUnavailableAtStartup` | `eMule` | `true` only when `BindInterface` is non-empty | Boolean; forced false when no bind interface is configured. | Connection page bind-protection checkbox. | None |
| `ExitOnBindInterfaceLoss` | `eMule` | `false` | Boolean; forced false when no bind interface is configured. | Connection page bind-loss checkbox. | None |
| `RandomizePortsOnStartup` | `eMule` | `false` | Boolean; when true, TCP/UDP ports are randomized during load before save. | Connection page checkbox. | None |
| `ConditionalTCPAccept` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ConnectionTimeout` | `eMule` | `30` seconds | Minimum `5`; no explicit max. | Tweaks advanced tree numeric field. | None |
| `DownloadTimeout` | `eMule` | `75` seconds | Minimum `5`; no explicit max. | Tweaks advanced tree numeric field. | None |
| `Reconnect` | `eMule` | `true` | Boolean. | Connection/server page checkbox. | None |
| `Serverlist` | `eMule` | `false` | Boolean. | Server page checkbox. | None |
| `AddServersFromServer` | `eMule` | `false` | Boolean. | Server page checkbox. | None |
| `AddServersFromClient` | `eMule` | `false` | Boolean. | Server page checkbox. | None |
| `Autoconnect` | `eMule` | `false` | Boolean. | Connection/server page checkbox. | `autoConnect`, PATCH boolean |
| `AutoConnectStaticOnly` | `eMule` | `false` | Boolean. | Server page checkbox. | None |
| `DeadServerRetry` | `eMule` | `1` | Range `1..MAX_SERVERFAILCOUNT`; low direct values use default, high values clamp. | Server page numeric field. | None |
| `SafeServerConnect` | `eMule` | `false` | Boolean. | Server page checkbox. | `safeServerConnect`, PATCH boolean |
| `ServerKeepAliveTimeout` | `eMule` | `0` ms | Persisted in ms; Tweaks edits minutes; range is the `0..1440` minute equivalent. | Tweaks advanced tree numeric field. | None |
| `YourHostname` | `eMule` | empty string | String. | Server/connection page text field. | None |
| `NetworkED2K` | `eMule` | `true` | Boolean. | Connection page checkbox. | `networkEd2k`, PATCH boolean |
| `NetworkKademlia` | `eMule` | `true` | Boolean. | Connection page checkbox. | `networkKademlia`, PATCH boolean |
| `Ed2kSearchMaxResults` | `eMule` | `0` | Non-negative; `0` means uncapped. | Tweaks advanced tree numeric field. | None |
| `Ed2kSearchMaxMoreRequests` | `eMule` | `0` | Non-negative; `0` means uncapped. | Tweaks advanced tree numeric field. | None |
| `KadFileSearchTotal` | `eMule` | `750` | Clamped `100..5000`. | Tweaks advanced tree numeric field. | None |
| `KadKeywordSearchTotal` | `eMule` | `750` | Clamped `100..5000`. | Tweaks advanced tree numeric field. | None |
| `KadFileSearchLifetime` | `eMule` | `90` seconds | Clamped `30..180`. | Tweaks advanced tree numeric field. | None |
| `KadKeywordSearchLifetime` | `eMule` | `90` seconds | Clamped `30..180`. | Tweaks advanced tree numeric field. | None |
| `IncomingDir` | `eMule` | default incoming directory | Empty/missing uses `GetDefaultDirectory(EMULE_INCOMINGDIR, true)`; path is canonicalized. | Directories page path field. | None |
| `TempDir` | `eMule` | default temp directory | Empty/missing uses `GetDefaultDirectory(EMULE_TEMPDIR, true)`; path is canonicalized. | Directories page path field. | None |
| `TempDirs` | `eMule` | empty string | Additional temp dirs as `|` separated list; entries are canonicalized. | Directories page list. | None |
| `MaxSourcesPerFile` | `eMule` | `600` | Positive-or-default. | Connection/files page numeric field. | `maxSourcesPerFile`, PATCH `1..2147483647` |
| `AddNewFilesPaused` | `eMule` | `false` | Boolean. | Files page checkbox. | None |
| `PreviewPrio` | `eMule` | `false` | Boolean. | Files page checkbox. | None |
| `AllocateFullFile` | `eMule` | `false` | Boolean. | Files page checkbox. | None |
| `SparsePartFiles` | `eMule` | `false` | Boolean. | Files page checkbox. | None |
| `CommitFiles` | `eMule` | `1` | Direct INI value is loaded as integer; Files page writes `0`, `1`, or `2`. | Files page radio group. | None |
| `MinFreeDiskSpaceConfig` | `eMule` | `1` GiB | Persisted bytes; clamped to `1..5120` GiB. | Files page edits GiB. | None |
| `MinFreeDiskSpaceTemp` | `eMule` | `5` GiB | Persisted bytes; clamped to `5..5120` GiB. | Files page edits GiB. | None |
| `MinFreeDiskSpaceIncoming` | `eMule` | `5` GiB | Persisted bytes; clamped to `5..5120` GiB. | Files page edits GiB. | None |
| `AutoArchivePreviewStart` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ExtractMetaData` | `eMule` | `1` | Values above `1` normalize to `1`; UI exposes `0`/`1`. | Files page checkbox/radio behavior. | None |
| `MediaInfo_MediaInfoDllPath` | `eMule` | `MEDIAINFO.DLL` | Hidden profile-only path; `<noload>` disables optional DLL loading. Absolute paths are tried directly; relative paths are resolved under the app folder. | None | None |
| `MediaInfo_RIFF` | `eMule` | `true` | Hidden profile-only boolean enabling the built-in RIFF fallback probe. | None | None |
| `MediaInfo_RM` | `eMule` | `true` | Hidden profile-only boolean enabling the built-in RealMedia fallback probe. | None | None |
| `MediaInfo_WM` | `eMule` | `true` | Hidden profile-only boolean enabling the built-in Windows Media fallback probe when compiled. | None | None |
| `MediaInfo_MediaDet` | `eMule` | `true` | Hidden profile-only boolean enabling legacy DirectShow MediaDet as the File Info last fallback. | None | None |
| `MediaInfo_ID3LIB` | `eMule` | `true` | Hidden profile-only boolean enabling the retained MPEG-audio `id3lib` fallback. | None | None |
| `ShowSharedFilesDetails` | `eMule` | `true` | Boolean. | Shared files/UI page checkbox. | None |
| `AutoShowLookups` | `eMule` | `true` | Boolean. | Kad/display page checkbox. | None |
| `RemoveFilesToBin` | `eMule` | `true` | Boolean. | Files page checkbox. | None |
| `RememberCancelledFiles` | `eMule` | `true` | Boolean. | Files page checkbox. | None |
| `RememberDownloadedFiles` | `eMule` | `true` | Boolean. | Files page checkbox. | None |
| `AutoClearCompleted` | `eMule` | `false` | Boolean. | Files/display page checkbox. | None |
| `AutoBroadbandIO` | `eMule` | `true` | Boolean. | Tweaks storage/persistence checkbox. | `autoBroadbandIo`, PATCH boolean |
| `FileBufferSize` | `eMule` | `67108864` bytes | Clamped to `16` KiB through `512` MiB. | Tweaks slider edits KiB. | None |
| `FileBufferTimeLimit` | `eMule` | `120` seconds | Clamped `1..86400` seconds; persisted as milliseconds. | Tweaks advanced tree numeric field. | None |
| `QueueSize` | `eMule` | `10000` | Clamped `2000..10000`. | Tweaks advanced tree numeric field. | `queueSize`, PATCH `2000..10000` |
| `DAPPref` | `eMule` | `true` | Boolean. | Files/download behavior checkbox. | `newAutoDown`, PATCH boolean |
| `UAPPref` | `eMule` | `true` | Boolean. | Files/upload behavior checkbox. | `newAutoUp`, PATCH boolean |
| `UseCreditSystem` | `eMule` | `true` | Boolean. | Security page checkbox. | `creditSystem`, PATCH boolean |
| `ShowRatesOnTitle` | `eMule` | `true` | Boolean. | Display page checkbox. | None |
| `ShowDwlPercentage` | `eMule` | `true` | Boolean. | Display page checkbox. | None |
| `IndicateRatings` | `eMule` | `true` | Boolean. | Display/files page checkbox. | None |
| `ToolTipDelay` | `eMule` | `1` | Clamped `0..32`. | Display page numeric field. | None |
| `ToolbarSetting` | `eMule` | `0099010203040506070899091011` | String. | Toolbar page. | None |
| `ToolbarBitmap` | `eMule` | empty string | String. | Toolbar page path field. | None |
| `ToolbarBitmapFolder` | `eMule` | default toolbar directory | Empty uses `GetDefaultDirectory(EMULE_TOOLBARDIR, true)`. | Toolbar page path field. | None |
| `ToolbarLabels` | `eMule` | `CMuleToolbarCtrl::GetDefaultLabelType()` | Enum value from toolbar control. | Toolbar page combo/radio. | None |
| `ToolbarIconSize` | `eMule` | `32` | Direct INI value is loaded as integer; toolbar menu writes `16` or `32`. | Toolbar context menu. | None |
| `WinaTransToolbar` | `eMule` | `true` | Boolean. | Toolbar/display checkbox. | None |
| `ShowDownloadToolbar` | `eMule` | `true` | Boolean. | Display/download checkbox. | None |
| `SkinProfile` | `eMule` | empty string | String. | Display/skin selector. | None |
| `SkinProfileDir` | `eMule` | default skin directory | Empty uses `GetDefaultDirectory(EMULE_SKINDIR, true)`. | Display/skin path field. | None |
| `DateTimeFormat` | `eMule` | `%A, %c` | String; main format cannot be saved empty through UI. | Tweaks advanced tree text field. | None |
| `DateTimeFormat4Log` | `eMule` | `%c` | String; log format cannot be saved empty through UI. | Tweaks advanced tree text field. | None |
| `DateTimeFormat4Lists` | `eMule` | `%c` | String; direct INI empty is allowed. | Tweaks advanced tree text field. | None |
| `TransferDoubleClick` | `eMule` | `true` | Boolean. | Display/files page option. | None |
| `ShowOverhead` | `eMule` | `false` | Boolean. | Display/statistics checkbox. | None |
| `ShowInfoOnCatTabs` | `eMule` | `false` | Boolean. | Display checkbox. | None |
| `ShowCopyEd2kLinkCmd` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `FilterServersByIP` | `eMule` | `false` | Boolean. | Security page checkbox. | None |
| `FilterLevel` | `eMule` | `127` | Integer; no explicit load clamp. | Security page numeric field. | None |
| `FilterBadIPs` | `eMule` | `true` | Boolean. | Security page checkbox. | None |
| `SecureIdent` | `eMule` | `true` | Boolean. | Security page checkbox. | None |
| `CryptLayerRequested` | `eMule` | `true` | Boolean. | Security/obfuscation page checkbox. | None |
| `CryptLayerRequired` | `eMule` | `false` | Boolean. | Security/obfuscation page checkbox. | None |
| `CryptLayerSupported` | `eMule` | `true` | Boolean. | Security/obfuscation page checkbox. | None |
| `EnableSearchResultSpamFilter` | `eMule` | `true` | Boolean. | Security/search page checkbox. | None |
| `CheckFileOpen` | `eMule` | `true` | Boolean. | Files/security checkbox. | None |
| `SeeShare` | `eMule` | `vsfaNobody` | Direct INI enum value; Security page writes `0` everybody, `1` friends, or `2` nobody. | Security page radio group. | None |
| `AdvancedSpamFilter` | `eMule` | `true` | Boolean. | Security page checkbox. | None |
| `MessagesFromFriendsOnly` | `eMule` | `false` | Boolean. | Messages page checkbox. | None |
| `MessageFromValidSourcesOnly` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `MessageUseCaptchas` | `eMule` | `true` | Boolean. | Messages page checkbox. | None |
| `MessageEnableSmileys` | `eMule` | `true` | Boolean. | Messages page checkbox. | None |
| `MessageFilter` | `eMule` | `fastest download speed|fastest eMule` | String. | Messages page text field. | None |
| `CommentFilter` | `eMule` | `http://|https://|ftp://|www.|ftp.` | String; loaded value is lowercased. | Messages/comments page text field. | None |
| `NotifierConfiguration` | `eMule` | config-dir `Notifier.ini` | String path. | Notification page path field. | None |
| `NotifyOnDownload` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifyOnNewDownload` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifyOnChat` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifyOnLog` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifyOnImportantError` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifierPopEveryChatMessage` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifierPopNewVersion` | `eMule` | `false` | Boolean. | Notification page checkbox. | None |
| `NotifierDisplayMode` | `eMule` | `1` | Valid modes: `0` custom popup, `1` Windows toast, `2` classic tray balloon; invalid values fall back to toast. | Notification page radio group; tray balloon can force tray icon visibility for delivery. | None |
| `NotifierUseSound` | `eMule` | `0` | Stored notifier sound enum. | Notification page combo/radio. | None |
| `NotifierSoundPath` | `eMule` | empty string | String path. | Notification page path field. | None |
| `EnableUPnP` | `UPnP` | `true` | Boolean. | Connection/UPnP page checkbox and wizard flow. | None |
| `CloseUPnPOnExit` | `UPnP` | `true` | Boolean. | Connection/UPnP page checkbox. | None |
| `BackendMode` | `UPnP` | `0` | Clamped to valid backend modes `0..2`; `0` is automatic. | UPnP page combo. | None |

## Broadband And Branch-Added Policy

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `MaxUploadClientsAllowed` | `UploadPolicy` | `8` | Clamped `1..32`. | Tweaks broadband policy field. | `maxUploadSlots`, PATCH `1..32` |
| `SlowUploadThresholdFactor` | `UploadPolicy` | `0.33` | Clamped `0.10..1.0`. | Tweaks broadband policy field. | None |
| `SlowUploadGraceSeconds` | `UploadPolicy` | `30` | Clamped `5..300`. | Tweaks broadband policy field. | None |
| `SlowUploadWarmupSeconds` | `UploadPolicy` | `60` | Clamped `0..3600`. | Tweaks broadband policy field. | None |
| `ZeroUploadRateGraceSeconds` | `UploadPolicy` | `10` | Clamped `3..120`. | Tweaks broadband policy field. | None |
| `SlowUploadCooldownSeconds` | `UploadPolicy` | `120` | Clamped `10..3600`. | Tweaks broadband policy field. | None |
| `LowRatioBoostEnabled` | `UploadPolicy` | `true` | Boolean. | Tweaks broadband policy checkbox. | None |
| `LowRatioThreshold` | `UploadPolicy` | `0.5` | Clamped `0..2`. | Tweaks broadband policy field. | None |
| `LowRatioScoreBonus` | `UploadPolicy` | `50` | Clamped `0..500`. | Tweaks broadband policy field. | None |
| `LowIDScoreDivisor` | `UploadPolicy` | `2` | Clamped `1..8`. | Tweaks broadband policy field. | None |
| `SessionTransferLimitMode` | `UploadPolicy` | percent mode | Valid modes are disabled, percent, and MiB; invalid values normalize to percent. | Tweaks broadband policy combo/radio. | None |
| `SessionTransferLimitValue` | `UploadPolicy` | `55` | Percent mode clamps `1..100`; MiB mode clamps `1..4096`; disabled mode ignores the value after persistence bounding. | Tweaks broadband policy field uses mode-aware validation. | None |
| `SessionTimeLimitSeconds` | `UploadPolicy` | `3600` | Clamped `0..86400`; `0` disables time rotation. | Tweaks broadband policy field. | None |
| `GeoLocationLookupEnabled` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `GeoLocationUpdatePeriodDays` | `eMule` | `30` | `0` disables checks; nonzero range is `7..365`. | Tweaks rejects nonzero values outside `7..365`. | None |
| `GeoLocationLastUpdateTime` | `eMule` | `0` | Non-negative timestamp string. | Updated by geolocation updater. | None |
| `GeoLocationUpdateUrl` | `eMule` | `https://download.db-ip.com/free/dbip-city-lite-%Y-%m.mmdb.gz` | String URL template. | Documented-only endpoint override. | None |
| `IPFilterUpdateEnabled` | `eMule` | `false` | Boolean. | Security page checkbox. | None |
| `IPFilterUpdatePeriodDays` | `eMule` | `7` | Clamped `1..365`. | Security page rejects values outside `1..365`. | None |
| `IPFilterLastUpdateTime` | `eMule` | `0` | Non-negative timestamp string. | Updated by IP-filter updater. | None |
| `IPFilterUpdateUrl` | `eMule` | `https://upd.emule-security.org/ipfilter.zip` | String URL. | Security page text field; dropdown suggestions live in `AC_IPFilterUpdateURLs.dat`. | None |
| `RunCommandOnFileCompletion` | `FileCompletion` | `false` | Boolean. | Files page checkbox; when enabled, apply validates the configured program path. | None |
| `FileCompletionProgram` | `FileCompletion` | empty string | Trimmed string path. | Files page text/path field; invalid paths are rejected when completion commands are enabled. | None |
| `FileCompletionArguments` | `FileCompletion` | empty string | Trimmed string. | Files page text field. | None |

## WebServer Preference Matrix

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `Password` | `WebServer` | empty string | Stored admin password hash/string. | WebServer page password field. | None |
| `PasswordLow` | `WebServer` | empty string | Stored low-rights password hash/string. | WebServer page password field. | None |
| `ApiKey` | `WebServer` | generated 16-byte hex key | Empty direct INI value generates and saves a new key. | WebServer page key field/copy behavior. | Used for Web API auth, not exposed by preferences endpoint |
| `BindAddr` | `WebServer` | empty string | Empty means UI/default `0.0.0.0`; stored override is trimmed. | WebServer page validates empty/default or IPv4 literal. | None |
| `Port` | `WebServer` | `4711` | Valid port `1..65535`; invalid or `0` normalizes to default. | WebServer page numeric field. | None |
| `WebUseUPnP` | `WebServer` | `false` | Boolean. | WebServer page checkbox. | None |
| `Enabled` | `WebServer` | `false` | Boolean. | WebServer page checkbox. | None |
| `UseLowRightsUser` | `WebServer` | `false` | Boolean. | WebServer page checkbox. | None |
| `PageRefreshTime` | `WebServer` | `120` | Clamped `0..3600` seconds. | WebServer page numeric field. | None |
| `WebTimeoutMins` | `WebServer` | `5` | Clamped `0..1440` minutes. | WebServer page numeric field. | None |
| `MaxFileUploadSizeMB` | `WebServer` | `5` | Clamped `0..65535` MiB. | WebServer page numeric field. | None |
| `AllowAdminHiLevelFunc` | `WebServer` | `false` | Boolean. | WebServer page checkbox. | None |
| `AllowedIPs` | `WebServer` | empty string | Valid semicolon-separated IPv4 allow-list; invalid direct tokens are ignored on load. | WebServer page rejects invalid tokens and all-zero/all-ones addresses. | None |
| `UseHTTPS` | `WebServer` | `false` | Boolean. | WebServer page checkbox; when enabled and WebServer is enabled, cert/key files must exist. | None |
| `UseGzip` | `WebServer` | `true` when HTTP | Boolean; forced `false` when HTTPS is enabled. | WebServer page checkbox. | None |
| `HTTPSCertificate` | `WebServer` | empty string | String path. | WebServer page validates path when HTTPS and WebServer are enabled. | None |
| `HTTPSKey` | `WebServer` | empty string | String path. | WebServer page validates path when HTTPS and WebServer are enabled. | None |

## Additional Persisted Application Preferences

These are active persisted settings that are either older stock options,
cross-page options, or workflow switches that are not prominent enough to fit
the main UI groupings above.

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `DisableFirstTimeWizard` | `eMule` | `true` | Boolean. | Wizard/startup flow flag. | None |
| `DebugHeap` | `eMule` | `1` | Integer debug heap flag. | Debug/diagnostic option. | None |
| `WebMirrorAlertLevel` | `eMule` | `0` | Integer mirror/update alert level; `GetWebMirrorAlertLevel()` returns `0` when update notification is disabled. | Update/mirror notification state. | None |
| `UpdateNotifyTestClient` | `eMule` | `false` | Boolean. | Update notification test-client option. | None |
| `Scoresystem` | `eMule` | `true` | Boolean. | Server/file priority behavior option. | None |
| `SmartIdCheck` | `eMule` | `true` | Boolean. | Security/server identity behavior option. | None |
| `MinToTray` | `eMule` | `false` | Boolean; used when Aero glass path is not active. | Display/general minimize option. | None |
| `MinToTray_Aero` | `eMule` | `false` | Boolean; used when Aero glass path is active. | Display/general minimize option. | None |
| `StoreSearches` | `eMule` | `true` | Boolean. | Search UI history option. | None |
| `Splashscreen` | `eMule` | `false` | Boolean. | General/display checkbox. | None |
| `ConfirmExit` | `eMule` | `false` | Boolean. | General/display checkbox. | None |
| `TransflstRemainOrder` | `eMule` | `false` | Boolean. | Transfer-list ordering state/option. | None |
| `AutoTakeED2KLinks` | `eMule` | `false` | Boolean. | General/files link association option. | None |
| `3DDepth` | `eMule` | `5` | Direct INI value is loaded as integer; Display page slider writes `0..5`. | Display page slider. | None |
| `UpdateQueueListPref` | `eMule` | `false` | Boolean. | Files/queue display option. | None |
| `ManualHighPrio` | `eMule` | `false` | Boolean. | Server/files priority option. | None |
| `FullChunkTransfers` | `eMule` | `true` | Boolean. | Files/transfer behavior option. | None |
| `StartNextFile` | `eMule` | `0` | Direct INI value is loaded as integer; Files page writes `0` disabled, `1` next, `2` prefer same category, or `3` only same category. | Files/download-completion option. | None |
| `VideoPreviewBackupped` | `eMule` | `false` | Boolean. | Files/preview behavior option. | None |
| `Check4NewVersionDelay` | `eMule` | `5` days | Clamped `1..30`. | General/update option when available. | None |
| `WatchClipboard4ED2kFilelinks` | `eMule` | `false` | Boolean. | General/files checkbox. | None |
| `SearchMethod` | `eMule` | `0` | Startup normalizes to `0..3`; invalid stored values fall back to `1` server. Search UI writes `0` automatic, `1` server, `2` global, or `3` Kad. | Search method combo. | None |
| `VersionCheckLastAutomatic` | `eMule` | `0` | Integer timestamp/state. | Updated by version check. | None |
| `DisableKnownClientList` | `eMule` | `false` | Boolean. | Tweaks/diagnostic option. | None |
| `DisableQueueList` | `eMule` | `false` | Boolean. | Tweaks/diagnostic option. | None |
| `EnableScheduler` | `eMule` | `false` | Boolean. | Scheduler page enable. | None |
| `AutoFilenameCleanup` | `eMule` | `false` | Boolean. | Files/download naming option. | None |
| `FollowMajorityFilenameForNewDownloads` | `eMule` | `false` | Boolean. | Files/download naming option. | None |
| `FollowMajorityFilenameRequiredPercent` | `eMule` | `51` | Clamped `1..100`. | Files/download naming numeric field. | None |
| `FollowMajorityFilenameMinimumVotes` | `eMule` | `0` | Clamped `0..1000`. | Files/download naming numeric field. | None |
| `UseAutocompletion` | `eMule` | `true` | Boolean. | Search/message text completion option. | None |
| `VideoPlayer` | `eMule` | empty string | String path. | Files/player text/path field. | None |
| `VideoPlayerArgs` | `eMule` | empty string | String. | Files/player arguments field. | None |
| `WebTemplateFile` | `eMule` | executable-dir `eMule.tmpl` | String path; if default executable template is selected and config-dir `eMule.tmpl` exists, config-dir template is used. | WebServer/template option. | None |
| `FilenameCleanups` | `eMule` | `http|www.|.com|.de|.org|.net|shared|powered|sponsored|sharelive|filedonkey|` | Long string. | Files/download naming option. | None |
| `UseSimpleTimeRemainingComputation` | `eMule` | `false` | Boolean. | Tweaks/hidden transfer estimate option. | None |
| `A4AFSaveCpu` | `eMule` | `false` | Boolean. | Tweaks/hidden download-manager option. | None |
| `DebugLogLevel` | `eMule` | `DLP_VERYLOW` | Integer debug-log level. | Debug/tweaks option. | None |
| `DebugServerTCP` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugServerUDP` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugServerSources` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugServerSearches` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugClientTCP` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugClientUDP` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugClientKadUDP` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `DebugSearchResultDetailLevel` | `eMule` | `0` | Debug-build integer; release builds force runtime value to `0`. | Debug/tweaks option. | None |
| `KadUDPKey` | `eMule` | random `uint32` | Stored random Kad UDP key. | Internal protocol state. | None |
| `ShowWin7TaskbarGoodies` | `eMule` | `true` | Boolean. | Display/taskbar option. | None |
| `NotifierSendMail` | `eMule` | `false` | Boolean. | Notification mail option. | None |
| `NotifierMailAuth` | `eMule` | `0` | SMTP auth enum. | Notification mail option. | None |
| `NotifierMailTLS` | `eMule` | `0` | TLS mode enum. | Notification mail option. | None |
| `NotifierMailSender` | `eMule` | empty string | String. | Notification mail option. | None |
| `NotifierMailServer` | `eMule` | empty string | String. | Notification mail option. | None |
| `NotifierMailPort` | `eMule` | `0` | Stored as `uint16`. | Notification mail option. | None |
| `NotifierMailRecipient` | `eMule` | empty string | String. | Notification mail option. | None |
| `NotifierMailLogin` | `eMule` | empty string | String. | Notification mail option. | None |
| `NotifierMailPassword` | `eMule` | empty string | String. | Notification mail option. | None |
| `ProxyEnablePassword` | `Proxy` | `false` | Boolean. | Proxy page checkbox. | None |
| `ProxyEnableProxy` | `Proxy` | `false` | Boolean. | Proxy page checkbox. | None |
| `ProxyName` | `Proxy` | empty string | String host. | Proxy page text field. | None |
| `ProxyUser` | `Proxy` | empty string | String. | Proxy page text field. | None |
| `ProxyPassword` | `Proxy` | empty string | String. | Proxy page password field. | None |
| `ProxyPort` | `Proxy` | `1080` | Valid port `1..65535`; invalid or `0` uses default. | Proxy page numeric field. | None |
| `ProxyType` | `Proxy` | `PROXYTYPE_NOPROXY` | Clamped to valid proxy enum range through `PROXYTYPE_HTTP11`. | Proxy page combo. | None |
| `Mode` | `PerfLog` | `0` | Valid modes are `0` disabled, `1` one sample, `2` all samples; invalid values normalize to disabled. | Tweaks performance logging checkbox maps enabled state to all-samples mode. | None |
| `FileFormat` | `PerfLog` | `0` | Valid `0` CSV, `1` MRTG; invalid values normalize to CSV. | Tweaks performance logging format radio group. | None |
| `File` | `PerfLog` | config-dir default | Empty direct values use the format-specific default path. | Tweaks performance logging file field. | None |
| `Interval` | `PerfLog` | `5` minutes | Valid `1..1440` minutes; invalid values normalize to `5`. | Tweaks performance logging interval field rejects values outside `1..1440`. | None |

## Logging, IRC, And Hidden Runtime Matrix

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `CreateCrashDump` | `eMule` | `1` | Valid modes `0..2`; invalid values normalize to `0`. | Tweaks advanced tree. | None |
| `SaveLogToDisk` | `eMule` | `false` | Boolean. | Tweaks/logging checkbox. | None |
| `MaxLogFileSize` | `eMule` | `16777216` bytes | Tweaks edits KiB; UI range `0..1048576` KiB. | Tweaks advanced tree numeric field. | None |
| `MaxLogBuff` | `eMule` | `256` KiB | Range `16..1048576` KiB. | Tweaks advanced tree numeric field. | None |
| `LogFileFormat` | `eMule` | `0` | Valid `0` Unicode, `1` UTF-8. | Tweaks advanced tree combo/radio. | None |
| `VerboseOptions` | `eMule` | `true` | Boolean gate for verbose options. | Tweaks/logging checkbox. | None |
| `Verbose` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `FullVerbose` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `SaveDebugToDisk` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `DebugSourceExchange` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogBannedClients` | `eMule` | `true` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogRatingDescReceived` | `eMule` | `true` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogSecureIdent` | `eMule` | `true` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogFilteredIPs` | `eMule` | `true` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogFileSaving` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogA4AF` | `eMule` | `false` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `LogUlDlEvents` | `eMule` | `true` | Boolean, honored when verbose options are enabled. | Tweaks/logging checkbox. | None |
| `DetectTCPErrorFlooder` | `eMule` | `true` | Boolean. | Tweaks security checkbox. | None |
| `TCPErrorFlooderIntervalMinutes` | `eMule` | `60` | Clamped `1..1440`. | Tweaks security numeric field. | None |
| `TCPErrorFlooderThreshold` | `eMule` | `10` | Clamped `3..1000`. | Tweaks security numeric field. | None |
| `HighresTimer` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ICH` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `PreviewSmallBlocks` | `eMule` | `0` | Valid `0..2`. | Tweaks advanced tree combo/radio. | None |
| `BeepOnError` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `IconflashOnNewMessage` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `TxtEditor` | `eMule` | `notepad.exe` | String; UI rejects empty. | Tweaks advanced tree text field. | None |
| `MaxChatHistoryLines` | `eMule` | `100` | Clamped `1..10000`. | Tweaks advanced tree numeric field. | None |
| `MaxMessageSessions` | `eMule` | `50` | Clamped `1..10000`. | Tweaks advanced tree numeric field. | None |
| `RestoreLastMainWndDlg` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `RestoreLastLogPane` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `PreviewCopiedArchives` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `InspectAllFileTypes` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `PreviewOnIconDblClk` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ShowActiveDownloadsBold` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `UseSystemFontForMainControls` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ReBarToolbar` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ShowUpDownIconInTaskbar` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `AlwaysShowTrayIcon` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ShowVerticalHourMarkers` | `eMule` | `true` | Boolean stored in `[eMule]`, not `[Statistics]`. | Tweaks/statistics checkbox. | None |
| `ForceSpeedsToKB` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `ExtraPreviewWithMenu` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `KeepUnavailableFixedSharedDirs` | `eMule` | `false` | Boolean. | Tweaks advanced tree checkbox. | None |
| `PartiallyPurgeOldKnownFiles` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `RearrangeKadSearchKeywords` | `eMule` | `true` | Boolean. | Tweaks advanced tree checkbox. | None |
| `AllowLocalHostIP` | `eMule` | `false` | Boolean. | Documented-only. | None |
| `CryptTCPPaddingLength` | `eMule` | `128` | Max `254`. | Documented-only protocol knob. | None |
| `UserSortedServerList` | `eMule` | `false` | Boolean. | Server-list state, not a normal workflow setting. | None |
| `DontRecreateStatGraphsOnResize` | `eMule` | `false` | Boolean. | Documented-only rendering workaround. | None |
| `StraightWindowStyles` | `eMule` | `0` | Integer legacy window style flag. | Documented-only. | None |
| `RTLWindowsLayout` | `eMule` | `false` | Boolean. | Locale/layout state. | None |
| `DefaultIRCServerNew` | `eMule` | `ircchat.emule-project.net` | String. | IRC page text field. | None |
| `IRCNick` | `eMule` | empty string | String. | IRC page text field; current nick change can trigger reconnect handling. | None |
| `IRCAddTimestamp` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCUseFilter` | `eMule` | `true`, then false if filter name is empty | Boolean; empty `IRCFilterName` disables it after load. | IRC page checkbox. | None |
| `IRCFilterName` | `eMule` | empty string | String. | IRC page text field. | None |
| `IRCFilterUser` | `eMule` | `0` | Direct INI value is loaded as integer; IRC page numeric field accepts unsigned text up to five digits. | IRC page numeric field. | None |
| `IRCPerformString` | `eMule` | empty string | String. | IRC page text field. | None |
| `IRCUsePerform` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCListOnConnect` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCAcceptLink` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCAcceptLinkFriends` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCSoundEvents` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCIgnoreMiscMessages` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCIgnoreJoinMessages` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCIgnorePartMessages` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCIgnoreQuitMessages` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCIgnorePingPongMessages` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCIgnoreEmuleAddFriendMsgs` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCAllowEmuleAddFriend` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCIgnoreEmuleSendLinkMsgs` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCHelpChannel` | `eMule` | `false` | Boolean. | IRC page checkbox. | None |
| `IRCEnableSmileys` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |
| `IRCEnableUTF8` | `eMule` | `true` | Boolean. | IRC page checkbox. | None |

## Statistics And Presentation State

These keys are persisted in `preferences.ini`, but they are state or
presentation settings rather than core behavior preferences.

| Key | Section | Default | Persistence and range | UI behavior | REST |
| --- | --- | --- | --- | --- | --- |
| `StatGraphsInterval` | `eMule` | `3` | Clamped maximum `200`; direct negative values use default. | Statistics page graph update slider/field. | None |
| `StatsInterval` | `eMule` | `5` | Clamped maximum `200`; direct negative values use default. | Statistics page tree update slider/field. | None |
| `StatsFillGraphs` | `eMule` | `false` | Boolean. | Statistics page checkbox. | None |
| `VariousStatisticsMaxValue` | `eMule` | `100` | Positive-or-default, then minimum `1`. | Statistics page graph scale field. | None |
| `StatsAverageMinutes` | `eMule` | `5` | Clamped `1..100`. | Statistics page average-time slider/field. | None |
| `SaveInterval` | `Statistics` | `60` | Direct INI value is loaded as integer; no current UI control found. | Internal statistics save cadence. | None |
| `statsConnectionsGraphRatio` | `Statistics` | `3` | Valid set `1,2,3,4,5,10,20`; invalid direct values use `3`. | Statistics preferences. | None |
| `statsExpandedTreeItems` | `Statistics` | `111000000100000110000010000011110000010010` | String state. | Statistics tree state. | None |
| `StatColor0`..`StatColor14` | `Statistics` | `ResetStatsColor` defaults | Color values. | Statistics color UI. | None |
| `HasCustomTaskIconColor` | `Statistics` | `false` | Boolean. | Task icon color state. | None |
| `HyperTextFont` | `eMule` | zeroed `LOGFONT` | Binary/font serialized value. | Display/font UI. | None |
| `LogTextFont` | `eMule` | zeroed `LOGFONT` | Binary/font serialized value. | Display/font UI. | None |
| `LogErrorColor` | `eMule` | member default | Color parser. | Display/log color UI. | None |
| `LogWarningColor` | `eMule` | member default | Color parser. | Display/log color UI. | None |
| `LogSuccessColor` | `eMule` | member default | Color parser. | Display/log color UI. | None |

## REST Preference Contract

The REST preference endpoint intentionally exposes only this curated subset.
Unknown mutable preference names are rejected by `ParseMutablePreferenceName`.
REST PATCH values are validated before setters run, so clients receive explicit
errors instead of relying on silent INI/setter normalization.

| REST field | Backing setting | GET | PATCH validation | Persistence effect |
| --- | --- | --- | --- | --- |
| `uploadLimitKiBps` | `MaxUpload` | Yes | Integer `1..4294967294` | Saves `MaxUpload` |
| `downloadLimitKiBps` | `MaxDownload` | Yes | Integer `1..4294967294` | Saves `MaxDownload` |
| `maxConnections` | `MaxConnections` | Yes | Integer `1..2147483647` | Saves `MaxConnections` |
| `maxConnectionsPerFiveSeconds` | `MaxConnectionsPerFiveSeconds` | Yes | Integer `1..2147483647` | Saves `MaxConnectionsPerFiveSeconds` |
| `maxSourcesPerFile` | `MaxSourcesPerFile` | Yes | Integer `1..2147483647` | Saves `MaxSourcesPerFile` |
| `uploadClientDataRate` | derived slot target | Yes | Integer `1..4294967295` | Derives and saves `MaxUploadClientsAllowed` |
| `maxUploadSlots` | `MaxUploadClientsAllowed` | Yes | Integer `1..32` | Saves `[UploadPolicy] MaxUploadClientsAllowed` |
| `queueSize` | `QueueSize` | Yes | Integer `2000..10000` | Saves `QueueSize` |
| `autoConnect` | `Autoconnect` | Yes | Boolean | Saves `Autoconnect` |
| `newAutoUp` | `UAPPref` | Yes | Boolean | Saves `UAPPref` |
| `newAutoDown` | `DAPPref` | Yes | Boolean | Saves `DAPPref` |
| `creditSystem` | `UseCreditSystem` | Yes | Boolean | Saves `UseCreditSystem` |
| `safeServerConnect` | `SafeServerConnect` | Yes | Boolean | Saves `SafeServerConnect` |
| `networkKademlia` | `NetworkKademlia` | Yes | Boolean | Saves `NetworkKademlia` |
| `networkEd2k` | `NetworkED2K` | Yes | Boolean | Saves `NetworkED2K` |
| `autoBroadbandIo` | `AutoBroadbandIO` | Yes | Boolean | Saves `AutoBroadbandIO` |

## Explicit Non-Preference Scope

The transfer totals, overhead counters, connection counters, server high-water
marks, splitter positions, category records, and last-selected UI panes stored
in `preferences.ini` are intentionally excluded from this matrix. They are
state/counter records, not user preference contracts. They are summarized in
the architecture document.
