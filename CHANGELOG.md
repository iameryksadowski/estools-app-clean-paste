# ES Tools Clean Paste (app) Changelog

## [1.0.1] - 2026-10-01

### Added

- **About Clean Paste** in the menu bar menu: the tool, its version and build, ES Tools, the author (Eryk Sadowski) and links to the source code, changelog and license.
- **Add to Raycast** in Settings > General: saves Paste Clean, Repair Clipboard, Settings and About as Raycast Quicklinks ("Clean Paste for Raycast.json" in Downloads) and opens Raycast for its Import Quicklinks command; give them Raycast hotkeys if you like.
- `estools-clean-paste://about` link.
- The menu bar menu shows the installed version at the bottom, so you can see at a glance that an update went through.

### Changed

- After an update that takes away the Accessibility permission, Clean Paste opens its settings with the one-click way back.
- A paste started from a link (Raycast, scripts) waits a moment longer, so the launcher can close and the target app comes back first.

## [1.0.0] - 2026-09-29

### Added

- Menu bar app: **Paste Clean** cleans the clipboard and pastes it into the app you are in; **Repair Clipboard** cleans it in place for a manual Cmd+V. Both with global shortcuts (Paste Clean: Control+Option+Command+V).
- Keeps bold, italic, underline, links, line breaks, non-breaking spaces, lists and simple tables; drops backgrounds, colors and fonts. Markdown becomes formatted text. Em and en dashes become "-", typographic quotes become " and '.
- Settings: shortcuts, dashes, quotes, font size (12 px by default, like Apple Mail), open at login, confirmation, updates, Accessibility status. The Dock icon shows only while the settings window is open.
- `cleanpaste` command line tool for Terminal, scripts and AI assistants, installed from the settings.
- In-app updates with the changelog, after the user agrees.
- `estools-clean-paste://paste`, `://repair` and `://settings` links for Raycast and scripts.
