# Changelog

## 0.1.3 — 2026-03-17

### Fixed

- Fixed `--version` flag showing `v0.1.0` instead of the actual release version

## 0.1.2 — 2026-03-17

### Fixed

- Fixed ARB file path pattern in generated `i18n.json` from `[locale].arb` to `app_[locale].arb` to match Flutter's standard naming convention

## 0.1.1 — 2026-03-17

### Fixes

- **`autolingo init`** — migrated from `.lingo` to `i18n.json` and updated configuration payload to match Schema version 1.15.

## 0.1.0 — 2026-03-17

Initial release. 🎉

### Features

- **`autolingo init`** — scaffold `l10n/`, `l10n.yaml`, and `i18n.json` config files
- **`autolingo scan`** — regex-based extraction of UI strings from `./lib` (Text, titles, hints, tooltips, buttons, SnackBars)
- **`autolingo generate`** — write `l10n/app_en.arb` with auto-generated camelCase keys
- **`autolingo translate`** — shell out to Lingo.dev for AI-powered translation into 5+ languages
- Automatic deduplication and filtering (skips interpolation, constants, file paths, numbers)
- Polished CLI output with ANSI colors (green ✓ / yellow ● / red ✗), branded headers, and styled help screen
- `--version` and `--help` flags

### Runtime (optional)

- `AutoLingoApp` wrapper widget with API key config
- `AutoText` drop-in replacement for `Text` with automatic translation
- `TranslationCache` backed by `SharedPreferences`
- `LocaleDetector` for device language detection
