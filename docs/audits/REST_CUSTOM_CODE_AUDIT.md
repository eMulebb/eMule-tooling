# REST Custom Code Audit

This note tracks REST and compatibility-bridge helper code that was reviewed
against the workspace rule to prefer existing project, platform, standard
library, or pinned dependency APIs before writing custom logic.

## Current Findings

- `WebServerJsonSeams::TryNormalizeSearchText` now uses the Windows
  `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)` decoder for strict
  UTF-8 validation. This replaced a draft custom UTF-8 scanner before commit.
- `Ini2Helpers.h` already uses the same strict Windows decoder for UTF-8 INI
  text, so REST search validation is aligned with existing workspace encoding
  practice.
- `StringConversion.cpp::utf8towc` now delegates to the Windows
  `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)` decoder instead of
  carrying a hand-written UTF-8 scanner. Existing `ByteStreamToWideChar`
  fallback behavior remains responsible for non-UTF-8 legacy byte streams.
- `GeoLocation.cpp` now uses the same strict Windows UTF-8 decoder for MMDB
  country and city strings; malformed payload text is ignored instead of
  guessed through an ANSI fallback.
- `WebServerJsonSeams::UrlEncodeUtf8`, `UrlDecodeUtf8`,
  `TryParseQueryString`, and `WebServerQBitCompatSeams::TryParseFormBody`
  remain local helpers intentionally. Windows URL canonicalization helpers such
  as `InternetCanonicalizeUrl` operate on whole URLs and browser-style
  canonicalization rules, which are not a safe replacement for strict REST path
  segments, Torznab query parameters, and nested qBittorrent form values.
- Torznab API-key checks now reuse the same normalized Torznab query parser as
  request dispatch, so malformed or duplicate query parameters are classified
  as `400 Bad Request` before authentication instead of being hidden as an auth
  miss.
- qBittorrent compatibility filters now reuse the shared query parser for the
  optional `category` filter. Malformed or duplicate category query fields fail
  closed with `400 Bad Request` instead of widening to an unfiltered transfer
  list, and valid category filter text now passes through the same native
  category-name normalization policy used by create/add/set-category requests.
- qBittorrent compatibility request classification now mirrors native `/api/v1`
  routing: the dispatcher recognizes the raw `/api/v2` namespace first, then
  the compatibility handler runs strict shared path decoding and returns
  `400 Bad Request` for malformed path escapes.
- Torznab compatibility request classification now follows the same pattern:
  raw `/indexer/emulebb/api` malformed-path candidates are routed to the
  compatibility handler, which uses the shared REST path-escape validator
  before authentication and query parsing.
- qBittorrent session-cookie matching now parses exact semicolon-delimited
  cookie pairs instead of accepting a matching `SID=...` suffix attached to a
  different cookie name.
- qBittorrent compatibility login validation now lives in the qBit seam and
  requires the exact configured username plus API key. This keeps credential
  parsing local to the form decoder while avoiding another controller-only
  auth rule.
- Native REST, qBittorrent compatibility, and Torznab compatibility now share
  the same exported `WebServerJson` CString/std::string conversion helpers for
  raw request bytes, UTF-8 JSON payload text, and API-key comparisons. This
  removed adapter-local copies of the same conversion code while preserving the
  compatibility-specific response formats.
- Torznab bounded integers, Torznab category IDs, qBittorrent magnet size
  fields, and adapter JSON result sizes now reuse `WebServerJsonSeams`
  unsigned parsing helpers instead of carrying compatibility-local
  `atoi`/`strtoul`/`strtoull` conversions. Overflow handling is therefore
  shared with native `/api/v1` REST validation.
- Native REST endpoint ports, path IDs, and bounded query integers now route
  through the same strict unsigned-decimal parser before applying route-specific
  bounds. This removes remaining route-local `strtoul`/`strtoull` conversions.
- Native REST and qBittorrent compatibility JSON responses now share
  `WebServerJson::SerializeJsonUtf8`, which serializes through the pinned
  `nlohmann::json` dependency with the native REST replacement policy for
  invalid string data instead of carrying a qBit-local `dump()` wrapper.
- REST-adjacent shared-directory and shared-file filesystem work routes through
  `PathHelpers` and `LongPathSeams`: recursive directory collection uses
  `PathHelpers::ForEachDirectoryEntry`, directory identity checks use
  `LongPathSeams::TryGetResolvedDirectoryIdentity`, startup/duplicate path
  cache reads and writes use `LongPathSeams::OpenFile`, and cache replacement
  uses `LongPathSeams::MoveFileEx` plus `DeleteFileIfExists`. The broad app has
  older unrelated raw file-call sites, but those are outside the REST/Arr
  Release 1 ownership boundary.
- qBittorrent compatibility session ID generation now has explicit
  `CCriticalSection` ownership around the lazy session string. Arr
  compatibility cache state already uses `CCriticalSection`, the Arr in-flight
  search gate uses interlocked exchange operations, and native REST UI command
  dispatch uses synchronous `SendMessage` so stack-owned dispatch context
  remains live for the full UI-thread command.
- HTTP `Content-Length` parsing now uses a shared WebSocket seam backed by the
  strict REST unsigned-decimal parser instead of `atol`, rejecting signed,
  partial, overflowed, and oversized request bodies before `/api/v1`, Torznab,
  or qBittorrent compatibility dispatch.
- HTTP request-line parsing now lives in the same WebSocket seam and preserves
  exact method tokens instead of classifying by string prefix. Native `/api/v1`
  and qBittorrent compatibility already validate method tokens downstream;
  Torznab compatibility now rejects non-GET requests before search handling.
- qBittorrent compatibility route specs now use the exact HTTP method token and
  their declared auth requirement during dispatch, avoiding a second path-based
  auth allowlist.
- Native transfer delete confirmation now fails in the shared `/api/v1` route
  validator unless `deleteFiles` is explicitly `true`; shared-file removal
  still accepts either boolean because `false` is the clean unshare/exclude
  operation.
- Native transfer-add request bodies now validate `link`/`links` shape,
  non-empty link strings, and the optional `paused` boolean in the shared
  `/api/v1` route seam. The UI-command seam delegates to the same link parser
  for the final legacy eD2K parsing boundary.
- Native body-level category selectors now validate both `categoryName` and
  `categoryId` in `WebServerJsonSeams::ValidateCategorySelectorBody` before
  transfer add, transfer category mutation, or search-result download command
  dispatch.
- Native transfer PATCH request bodies now validate exactly one mutation
  family (`priority`, category selector, or `name`) in the shared route seam.
  Transfer rename trimming and empty-name rejection are shared between the
  route seam and command seam.
- Native shared-file PATCH request bodies now validate empty bodies, priority
  type, and paired `comment`/`rating` fields in the shared route seam. The
  command seam delegates comment/rating parsing to the same helper.
- Native shared-file add and shared-directory replacement bodies now validate
  path/root descriptor shape in the shared route seam before dispatch. Live
  path canonicalization and shareability checks remain in the command layer
  because they depend on current preferences and filesystem policy.
- Torznab compatibility search dispatch now consumes the native command seam's
  default search method token (`automatic`) instead of carrying an adapter-local
  Kad-only default.
- qBittorrent compatibility transfer delete parsing now adapts the optional
  qBit `deleteFiles` flag to eMule's native cancel semantics by always
  forwarding `deleteFiles:true` to the shared transfer-delete command.
- qBittorrent-compatible category creation now uses the same shared
  category-name normalization and UTF-8/control-character validation as native
  REST and qBit add/set-category requests.
- qBittorrent-compatible POST requests now fail closed before form parsing
  when a non-empty body is not declared as
  `application/x-www-form-urlencoded`, mirroring the native `/api/v1`
  JSON metadata gate while preserving qBit adapter response shapes.
- qBittorrent-compatible accepted no-op mutation routes (`setShareLimits`,
  `topPrio`, and `setForceStart`) now still parse their `hashes` form field
  through the shared qBit-to-native eD2K hash validator before returning
  success.
- Native `/api/v1` transfer responses and qBittorrent-compatible torrent info
  now share `WebApiSurfaceSeams::BuildTransferProgressRatio`. This keeps
  progress clamping and display precision consistent across the clean native
  surface and Arr/aMuTorrent-facing adapter shapes.
- REST hash validation remains local and domain-specific because the public API
  requires exactly 32 lowercase MD4 hex characters, not general binary or hash
  parsing.
- REST endpoint token parsing remains local for now because route tokens may be
  hostnames or addresses with ports. Windows IP parsers such as `InetPton` are
  useful only after the API deliberately narrows a route to numeric IP input.

## Reviewed Helper Ledger

| Area | Helper or surface | Decision | Reason and evidence |
|------|-------------------|----------|---------------------|
| UTF-8 validation | `WebServerJsonSeams::TryNormalizeSearchText`, `StringConversion.cpp::utf8towc`, `GeoLocation.cpp` MMDB text conversion | Replaced | Strict UTF-8 validation now uses Windows `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, ...)`; malformed text is rejected or ignored at the owning boundary instead of guessed by a custom scanner. |
| URL encoding | `WebServerJsonSeams::UrlEncodeUtf8` | Kept with reason | Compatibility links need RFC3986 component escaping for already-validated UTF-8 bytes. Windows whole-URL canonicalizers would also normalize URL shape, which is not the contract. Covered by native seam tests for spaces, plus signs, percent signs, and Torznab magnet display names. |
| URL decoding | `WebServerJsonSeams::TryUrlDecodeUtf8` | Kept with reason | REST route segments, query fields, Torznab parameters, qBit form fields, and nested magnet query strings share one strict percent decoder. It rejects malformed escapes before dispatch; Windows browser-style URL helpers are not a safe component-level replacement. |
| Query parsing | `WebServerJsonSeams::TryParseQueryString` and `TryParseUrlEncodedFields` | Kept with reason | Native REST and Torznab use one duplicate-rejecting decoded-field parser. Tests cover malformed escapes, duplicate query parameters, native query strings, Torznab query strings, and nested qBit magnet query strings. |
| qBit form/query parsing | `WebServerQBitCompatSeams::TryValidateFormRequestMetadata`, `TryParseFormBody`, qBit category request parsers, and qBit category filters | Kept with reason | qBittorrent compatibility needs `application/x-www-form-urlencoded` decoding with unique decoded field names and adapter-specific error text. The implementation now rejects non-form `Content-Type` values before parsing non-empty POST bodies, delegates decoding to the shared REST URL-encoded field parser, and routes category add/set/create/filter requests through the native category-name policy; tests cover metadata rejection, duplicate fields, empty names, malformed escapes, required field checks, trimming, and control-character rejection. |
| XML escaping | `WebServerArrCompatSeams::XmlEscape` | Kept with reason | No pinned XML writer is currently part of the lightweight Torznab feed path. The helper is intentionally narrow, has a Doxygen comment, and seam tests cover element and attribute metacharacters used by feed result titles, descriptions, links, GUIDs, and Torznab attributes. |
| Numeric parsing | `WebServerJsonSeams::TryParseUnsignedDecimalValue` and `TryParseJsonUInt64` consumers | Replaced/shared | Adapter-local `atoi`/`strtoul`/`strtoull` paths were removed. Native route bounds, native JSON numeric bodies, Torznab season/episode/year/category values, Torznab result size adaptation, qBit magnet sizes, and HTTP `Content-Length` now share strict unsigned parsing and overflow rejection. |
| Path canonicalization | Shared-directory REST, shared-file REST, static-file path seams, and category incoming paths | Replaced/shared | REST path entry points now route through `PathHelpers::CanonicalizePath`, `ParsePathRoot`, or `CanonicalizePathForComparison` before ownership checks and output echoing. Live evidence covers over-`MAX_PATH` Unicode roots, traversal rejection, missing-parent roots, category incoming-path echo, and shared-file long-path reload/list behavior. |
| REST/adapter file operations | Native REST shared-file and transfer delete commands plus Arr/qBit adapters | Replaced/shared | Source audit found no raw `CFile`, CRT stream, `CreateFile`, `FindFirstFile`, or attribute probes in the REST/adapter files. The only REST-side file deletion path is `ShellDeleteFile`, which delegates existence and direct deletion to `LongPathSeams`; native seam tests cover deep Unicode delete routing with and without recycle-bin mode. |
| Hash validation | REST and qBit eD2K hash selectors | Kept with reason | The API contract is domain-specific: exactly 32 lowercase MD4 hex characters for native selectors, with qBit compatibility normalizing accepted mutation hashes before native dispatch. Accepted qBit no-op mutation routes still pass through the same validator before returning success. General Windows or crypto parsers do not own this textual contract. |
| Transfer progress ratio | Native `/api/v1` transfer JSON and qBit torrent info JSON | Replaced/shared | Both surfaces now use `WebApiSurfaceSeams::BuildTransferProgressRatio`, which clamps zero/over-complete states and rounds to the shared REST scale instead of carrying raw ad hoc floating-point division in each controller. |
| Transfer add payload validation | Native `/api/v1` route seam and transfer-add command seam | Replaced/shared | `WebServerJsonSeams::ValidateTransferAddBody` owns the public `link`/`links` shape, non-empty link trimming, and optional `paused` type checks before dispatch. `WebApiCommandSeams::TryParseTransferAddLink` delegates to the same shared helper before the legacy eD2K parser verifies link semantics. Tests cover missing, conflicting, empty, non-string, and trimmed multi-link payloads plus live smoke error responses. |
| Category selector validation | Native transfer and search-result-download route bodies | Replaced/shared | `WebServerJsonSeams::ValidateCategorySelectorBody` now owns mutual exclusion, category-name normalization, category-id unsigned parsing, and category-id bounds for every route body that accepts category selectors. Tests cover conflicting selectors, malformed category names, negative IDs, and out-of-range IDs before command dispatch. |
| Transfer PATCH validation | Native `/api/v1/transfers/{hash}` route seam and transfer-rename command seam | Replaced/shared | `WebServerJsonSeams::ValidateTransferPatchBody` rejects empty PATCH bodies, mixed mutation families, non-string priority values, and empty rename targets before dispatch. `WebApiCommandSeams::TryParseTransferRenameRequest` delegates rename text trimming to the same shared helper. Tests cover route-level conflicts, bad priority shape, empty rename text, and smoke-level `400` responses. |
| Shared-file PATCH validation | Native `/api/v1/shared-files/{hash}` route seam and shared-file rating/comment command seam | Replaced/shared | `WebServerJsonSeams::ValidateSharedFilePatchBody` rejects empty PATCH bodies, non-string priority values, and incomplete or out-of-range comment/rating updates before dispatch. `WebApiCommandSeams::TryParseSharedFileRatingCommentRequest` delegates comment/rating parsing to the same shared helper. Tests cover route-level empty bodies, priority shape, missing rating, bad rating, and smoke-level `400` responses. |
| Shared path payload validation | Native `/api/v1/shared-files` and `/api/v1/shared-directories` route seams plus command path parsing | Replaced/shared | `WebServerJsonSeams::TryParsePathText`, `ValidateSharedFileAddBody`, and `ValidateSharedDirectoriesPatchBody` own public shape checks for non-empty path strings, root arrays, strict root descriptor fields, and boolean recursion flags. `WebServerJson.cpp::TryGetPathParam` delegates path text parsing to the same helper, while command handling keeps canonicalization and shareability checks that require live preference/filesystem state. Tests cover trimmed paths, empty paths, malformed roots, and smoke-level recursive-type rejection. |
| JSON construction | Native `/api/v1` and qBittorrent compatibility response assembly | Replaced/shared | Native REST and qBittorrent compatibility now share `WebServerJson::SerializeJsonUtf8`, backed by pinned `nlohmann::json` and the native REST invalid-string replacement policy. Native `/api/v1` success/error envelopes remain centralized in `BuildSuccessEnvelope` and `BuildErrorEnvelope`; qBit compatibility keeps its adapter-specific response shapes while reusing the serializer. |
| File I/O | REST-adjacent path and shared-file operations | Replaced/shared | Native REST shared-directory mutation, shared-file add/list/reload, transfer delete, and static file reads delegate filesystem work to `SharedDirectoryOps`, `SharedFileList`, `ShellDeleteFile`, `PathHelpers`, or `LongPathSeams`. Source audit covered REST controllers, Arr/qBit adapters, shared-directory enumeration, shared-file startup/duplicate cache reads and writes, and static reads; no REST-owned raw file I/O remains where a LongPath/project helper owns the behavior. |
| Concurrency and lifetime | REST command dispatch, Arr cache/search state, qBit session/auth state | Replaced/shared | qBit compatibility now guards lazy SID generation with `CCriticalSection`. Arr cache access is protected by `g_arrCompatCacheLock`, Arr search reservation uses interlocked compare/exchange, and native REST bridge commands use synchronous UI-thread `SendMessage` to keep stack dispatch context lifetime bounded. Stress evidence covers mixed native REST, adapters, malformed traffic, and legacy HTML GETs. |

## Resolved Cleanup

- ASCII trim/lower/decimal parsing now lives in shared REST parser primitives
  consumed by both native `/api/v1` routing and compatibility command helpers.
- Torznab media search parsing now reuses the native REST ASCII trim and
  whitespace-normalization helpers instead of carrying compatibility-local
  duplicates.
- Percent decoding now rejects malformed `%` escapes for REST path/query and
  qBittorrent form parsing. This remains local unless a pinned URL parser with
  exact RFC3986 component semantics is introduced.
