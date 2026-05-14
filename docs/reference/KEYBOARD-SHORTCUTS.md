# Keyboard Shortcuts

EMULE_KEYBOARD_SHORTCUT: this document records deliberate app-level keyboard
ownership for the native MFC shell. Update it with code changes that add,
remove, or repurpose shortcuts.

## Reserved App Shortcuts

| Shortcut | Owner | Behavior |
|----------|-------|----------|
| `Alt+X` | main shell | Cleanly exits through `CemuleDlg::OnClose()` and respects Prompt on exit. |
| `Alt+U` | main shell | Opens the existing floating hotmenu. |
| `Alt+T` | main shell | Opens the Tools popup. |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | main shell | Cycles primary toolbar panes. |

## Downloads List Shortcuts

These shortcuts are local to the Downloads file list. They operate on the
selected downloads and do not become global app accelerators.

| Shortcut | Behavior |
|----------|----------|
| `Ctrl+P` | Pauses selected downloads that can be paused. |
| `Ctrl+S` | Resumes selected downloads that can be resumed. |
| `Ctrl+T` | Stops selected downloads that can be stopped. |
| `Delete` | Cancels selected active downloads; removes completed downloads from the visible list. |
| `F2` | Renames one selected incomplete download; `Ctrl+F2` runs filename cleanup. |
| `Enter` | Opens the selected completed download when it can be opened. |
| `Alt+Enter` | Opens details for the selected download rows. |
| `Ctrl+C` | Copies selected download ED2K links. |
| `Ctrl+V` | Pastes a direct ED2K download link when available. |
| `Ctrl+F` | Starts list find. |

## Reserved Main-Shell Mnemonics

These native Alt mnemonics are treated as main-shell toolbar or hotmenu
ownership and should not be reused by modeless child panes:

`Alt+C`, `Alt+K`, `Alt+V`, `Alt+T`, `Alt+S`, `Alt+F`, `Alt+M`, `Alt+I`,
`Alt+A`, `Alt+O`, `Alt+H`, `Alt+U`, `Alt+X`.

## Search Pane Mnemonics

When Search is the active main pane, the Search parameter bar owns:

| Shortcut | Behavior |
|----------|----------|
| `Alt+N` | Focuses the Name textbox. |
| `Alt+Y` | Focuses Type. |
| `Alt+D` | Focuses Method. |
| `Alt+G` | Activates Search Go. |
| `Alt+E` | Activates More. |
| `Alt+R` | Activates Reset. |
| `Alt+L` | Activates Cancel. |

## Search Pane Navigation

| Shortcut | Behavior |
|----------|----------|
| `F6` | Toggles focus between the Search Name textbox and the search results list. |

## Mnemonic Policy

- EMULE_KEYBOARD_SHORTCUT: do not reassign `Alt+X`; it is the direct app-exit
  mnemonic.
- The old hidden hotmenu `Alt+X` button was retired; floating hotmenu ownership
  is now `Alt+U`, and Tools ownership is `Alt+T`.
- Search-local mnemonics deliberately avoid the reserved main-shell letters.
- Modal dialogs keep local keyboard behavior. The app-level shortcuts are for
  the main shell and its primary modeless UI.
- Localized `.rc` files are not normalized in this pass; default English
  resources define the reviewed policy.

## Manual Verification

- With Prompt on exit disabled, `Alt+X` should enter the normal shutdown
  progress path.
- With Prompt on exit enabled, `Alt+X` should show the existing confirmation
  before shutdown.
- `Alt+U` should open the floating hotmenu.
- `Alt+T` should open the Tools popup.
- In Search, `Alt+N` should focus the Name textbox without selecting existing
  text.
- In Search, `Alt+Y`, `Alt+D`, `Alt+G`, `Alt+E`, `Alt+R`, and `Alt+L` should
  drive Type, Method, Search Go, More, Reset, and Cancel through local native
  mnemonic behavior.
- In Search, `F6` should move focus between the Name textbox and the search
  results list.
- Outside Search, `Alt+N` should not switch panes or steal focus.
- Preferences, About, and confirmation dialogs should retain their normal
  local keyboard handling.
