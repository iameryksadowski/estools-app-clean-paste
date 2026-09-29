# ES Tools Clean Paste (app) Changelog

## [1.0.0] - 2026-09-29

### Added

- Menu bar app: **Paste Clean** cleans the clipboard and pastes it into the app you are in; **Repair Clipboard** cleans it in place for a manual Cmd+V. Both with global shortcuts (Paste Clean: Control+Option+Command+V).
- Keeps bold, italic, underline, links, line breaks, non-breaking spaces, lists and simple tables; drops backgrounds, colors and fonts. Markdown becomes formatted text. Em and en dashes become "-", typographic quotes become " and '.
- Settings: shortcuts, dashes, quotes, font size (12 px by default, like Apple Mail), open at login, confirmation, updates, Accessibility status. The Dock icon shows only while the settings window is open.
- `cleanpaste` command line tool for Terminal, scripts and AI assistants, installed from the settings.
- In-app updates with the changelog, after the user agrees.
- `estools-clean-paste://paste`, `://repair` and `://settings` links for Raycast and scripts.
