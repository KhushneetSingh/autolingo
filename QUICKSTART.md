<div align="center">

# 🌍 AutoLingo

**Localize your Flutter app in 3 commands.**

[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![pub package](https://img.shields.io/pub/v/autolingo?style=flat-square&logo=dart&color=00B4AB)](https://pub.dev/packages/autolingo)
[![Powered by Lingo.dev](https://img.shields.io/badge/Powered%20by-Lingo.dev-6C47FF?style=flat-square)](https://lingo.dev)

</div>

---

```bash
autolingo init        # scaffold l10n config
autolingo generate    # scan your app, write app_en.arb
autolingo translate   # AI-translate to 20+ languages via Lingo.dev
```

That's it. Your Flutter app now speaks Spanish, Hindi, French, German, and more.

---

## Install

> 📦 **[View on pub.dev →](https://pub.dev/packages/autolingo)**

```bash
dart pub global activate autolingo
```

## What it does

AutoLingo scans every `.dart` file in your Flutter project, finds all UI strings inside `Text()`, `AppBar`, buttons, dialogs, hints, and tooltips — then generates a standard Flutter ARB file and passes it to Lingo.dev for AI translation.

**No runtime packages. No widget wrapping. Pure Flutter standard localization, generated automatically.**

## Workflow

```
Flutter App (.dart files)
        ↓  autolingo scan + generate
  l10n/en.arb  (source — English)
        ↓  autolingo translate
  l10n/es.arb  (Spanish)
  l10n/hi.arb  (Hindi)
  l10n/fr.arb  (French)
  l10n/de.arb  (German)
        ↓  flutter gen-l10n
  AppLocalizations  (ready to use)
```

## Setup (once per project)

**1. Add to `pubspec.yaml`:**
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true
```

**2. Update `MaterialApp`:**
```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MyApp(),
)
```

**3. Replace hardcoded strings:**
```dart
// Before
Text("Welcome back")

// After
Text(AppLocalizations.of(context)!.welcomeBack)
```

## Detected widget patterns

```dart
Text("any string")
AppBar(title: Text("Title"))
ElevatedButton(child: Text("Submit"))
SnackBar(content: Text("Saved!"))
hintText: "Enter email"
labelText: "Password"
tooltip: "Delete"
helperText: "Required field"
```

## Config files created by `autolingo init`

**`l10n.yaml`** — tells Flutter where to find ARB files  
**`i18n.json`** — tells Lingo.dev which languages to target

Edit `i18n.json` to add/remove target languages:
```json
{
  "locale": {
    "source": "en",
    "targets": ["es", "hi", "fr", "de", "pt", "ja", "ko"]
  }
}
```

## Project layout

```
autolingo/
├── bin/autolingo.dart       ← CLI entry (4 commands)
└── lib/src/
    ├── extractor.dart       ← regex string scanner
    ├── arb_generator.dart   ← writes en.arb
    ├── lingo_runner.dart    ← calls npx lingo.dev run
    └── init_command.dart    ← scaffolds config files
```

## Requirements

- Dart `>=3.0.0`
- Flutter `>=3.0.0`
- Node.js (for `npx lingo.dev`)
- [Lingo.dev account](https://lingo.dev) (free)

---

<div align="center">

Built at **Hackathon 2026** · [📦 pub.dev](https://pub.dev/packages/autolingo) · [Lingo.dev](https://lingo.dev) · MIT License

</div>
