# Tools Menu Guide

The Tools menu is the power-user control surface for fast navigation,
maintenance, diagnostics, and direct config-file access.

## Organization

Tools is grouped by task:

- Session: connect/disconnect, show main panes, options, tray, exit
- Speed Quick Actions: upload/download/both throttle presets
- Folders: open important directories
- Categories: manage categories and edit category config
- Edit Config Files: open editable profile files in the configured text editor
- Network and Updates: first-run wizard, IP filter, direct download, server.met update, port test, firewall repair, geolocation update
- Maintenance: reload filters, rescan shared files, save preferences
- View Presets: apply stock, extended, or full table layouts
- Diagnostics: open logs, copy diagnostic snapshots, capture dumps

The goal is fast access without forcing users through Preferences for every
operational action.

## Session

Session actions mirror high-frequency toolbar behavior:

- connect, cancel connection, or disconnect depending on current state
- jump to Server, Transfers, Search, Shared Files, Messages, IRC, Statistics, or Options
- minimize to tray
- exit through the normal shutdown path

Use these actions when running from tray or when the toolbar is hidden or not
focused.

## Speed Quick Actions

Speed quick actions change limits for:

- upload only
- download only
- both upload and download together

Percentage actions apply to the current configured finite limit. They are
persisted through the same preference paths as normal limit changes, so they are
not just temporary live-session throttles.

## Folders

Folder actions open common locations:

- Incoming
- Temp
- Config
- Logs
- WebServer assets
- Skins
- Toolbar assets
- Executable directory

Use these instead of manually browsing through profile paths.

## Edit Config Files

The editor actions open text-backed config files directly:

- `preferences.ini`
- `ipfilter.dat`
- fake-file filter rules
- share-ignore rules
- `addresses.dat`
- `staticservers.dat`
- `webservices.dat`
- share directory files
- `Category.ini`
- `Notifier.ini`
- file comments
- `statistics.ini`

Edits are not all applied live. Use the matching reload action where one exists,
or restart when editing persistent startup settings.

## Categories

The category manager is the preferred way to rename, reorder, add, and remove
download categories. It protects categories that are still assigned to
downloads. Direct `Category.ini` editing is available for recovery and careful
bulk maintenance.

## Network And Updates

Network actions include:

- first-run wizard
- IP filter dialog
- direct ED2K download dialog
- server.met update from `addresses.dat`
- open ports test
- Windows Firewall repair
- geolocation database update

These actions belong together because they affect reachability, bootstrap, or
network metadata.

## Maintenance

Maintenance actions are safe operational refreshes:

- reload `ipfilter.dat`
- reload fake-file filter rules
- reload `shareignore.dat`
- rescan shared files
- save preferences now

Prefer these over restarting when the action has an explicit reload path.

## View Presets

View presets reset table layouts:

- Stock: conservative, classic columns
- Extended: power-user columns without everything visible
- Full: all reviewed columns visible

Each preset has two variants:

- preserve widths
- reset widths

Use reset widths when old profiles have cramped or broken column layouts.

## Diagnostics

Diagnostics actions include:

- open normal and verbose logs
- copy diagnostic snapshot JSON
- copy redacted diagnostic snapshot JSON
- capture mini dump
- capture full memory dump

Use redacted JSON for sharing unless exact addresses, paths, or command lines
are required for private diagnosis.

## Keyboard Notes

`Alt+T` opens the Tools popup. Keyboard shortcut details are maintained in
[Keyboard Shortcuts](KEYBOARD-SHORTCUTS.md) and are intentionally not duplicated
here.
