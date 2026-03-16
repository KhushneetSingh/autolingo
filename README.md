<div align="center">

```
 █████╗ ██╗   ██╗████████╗ ██████╗ ██╗     ██╗███╗   ██╗ ██████╗  ██████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██║     ██║████╗  ██║██╔════╝ ██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║██║     ██║██╔██╗ ██║██║  ███╗██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║██║╚██╗██║██║   ██║██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████╗██║██║ ╚████║╚██████╔╝╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝
```

### Zero-config localization for Flutter apps — powered by [Lingo.dev](https://lingo.dev)

[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Lingo.dev](https://img.shields.io/badge/Powered%20by-Lingo.dev-6C47FF?style=flat-square)](https://lingo.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Built at Hackathon](https://img.shields.io/badge/Built%20at-Hackathon%202026-FF6B6B?style=flat-square)](#)

<br/>

**Go from English-only to 20+ languages in under 5 minutes.**  
No ARB files to write. No translation keys to manage. No localization boilerplate.  
Just run three commands.

<br/>

[Getting Started](#-getting-started) · [How It Works](#-how-it-works) · [CLI Reference](#-cli-reference) · [Demo](#-demo) · [Contributing](#-contributing)

</div>

---

## The Problem

Every Flutter developer knows this pain:

```
Your app is ready.
You want to launch in Spanish, Hindi, French.
Flutter says: "Sure! Just create ARB files, define translation keys,
set up localization delegates, manage locale detection, handle fallbacks..."
```

Most developers give up and ship English-only. Not because they don't want to localize — because the setup is a **full day of boilerplate** for every app.

**AutoLingo fixes this.**

---

## The Solution

AutoLingo is a **Dart CLI tool** that:

1. **Scans** your existing Flutter app for all UI strings
2. **Generates** a standard `app_en.arb` file automatically
3. **Translates** it into any language via Lingo.dev AI

Your Flutter app doesn't change. No runtime packages. No widget wrapping. Just clean, standard Flutter localization — generated automatically.

---

## ✨ Before & After

### Before AutoLingo

```
❌ Manually create l10n/app_en.arb
❌ Manually create l10n/app_es.arb
❌ Manually create l10n/app_hi.arb
❌ Write 200+ translation keys by hand
❌ Set up localization delegates in MaterialApp
❌ Update every file when UI text changes
❌ Hours of setup. Ships English-only anyway.
```

### After AutoLingo

```bash
autolingo init       # 2 seconds
autolingo generate   # 5 seconds
autolingo translate  # 30 seconds
```

```
✅ l10n/en.arb   — generated
✅ l10n/es.arb   — translated (Spanish)
✅ l10n/hi.arb   — translated (Hindi)
✅ l10n/fr.arb   — translated (French)
✅ l10n/de.arb   — translated (German)
✅ Ready for flutter gen-l10n
```

---

## 🚀 Getting Started

### Prerequisites

- Dart SDK `>=3.0.0`
- Flutter `>=3.0.0`
- Node.js (for `npx lingo.dev`)
- A [Lingo.dev](https://lingo.dev) account (free)

### Install AutoLingo

```bash
dart pub global activate autolingo
```

Add Dart's pub cache to your PATH if needed:

```bash
# macOS / Linux
export PATH="$PATH:$HOME/.pub-cache/bin"

# Windows
set PATH=%PATH%;%APPDATA%\Pub\Cache\bin
```

### Verify installation

```bash
autolingo --version
# autolingo 0.1.0
```

---

## 📋 Full Workflow

### Step 1 — Initialize your Flutter project

```bash
cd your_flutter_app/
autolingo init
```

**What it creates:**

```
your_flutter_app/
  ├── l10n/              ← new folder
  ├── l10n.yaml          ← Flutter l10n config
  └── i18n.json          ← Lingo.dev config
```

---

### Step 2 — Scan your UI strings (dry run)

```bash
autolingo scan
```

**Sample output:**

```
AutoLingo — string scanner
Scanning ./lib...

Found 34 UI strings:
  • Cancel
  • Continue
  • Loading...
  • Settings
  • Upload Complete
  • Welcome to Ace
  • (28 more...)

Run 'autolingo generate' to create your ARB file.
```

---

### Step 3 — Generate the ARB file

```bash
autolingo generate
```

**Output:**

```
Generating ARB file...
Written: l10n/en.arb (34 strings) ✓

Next step: autolingo translate
```

**The generated `l10n/en.arb`:**

```json
{
  "@@locale": "en",
  "cancel": "Cancel",
  "@cancel": { "description": "Auto-extracted by AutoLingo" },
  "uploadComplete": "Upload Complete",
  "@uploadComplete": { "description": "Auto-extracted by AutoLingo" },
  "welcomeToAce": "Welcome to Ace",
  "@welcomeToAce": { "description": "Auto-extracted by AutoLingo" }
}
```

---

### Step 4 — Translate with Lingo.dev

```bash
# One-time login
npx lingo.dev@latest login

# Translate everything
autolingo translate
```

**Output:**

```
Running Lingo.dev translation...
✔ Authenticated as you@email.com
✔ Found 1 bucket(s)
✔ Prepared 5 translation task(s)
✔ Processing localization tasks...

Translation complete! Check your l10n/ folder.
```

**Result:**

```
l10n/
  ├── en.arb   ← source (English)
  ├── es.arb   ← Spanish
  ├── hi.arb   ← Hindi
  ├── fr.arb   ← French
  ├── de.arb   ← German
  └── pt.arb   ← Portuguese
```

---

### Step 5 — Generate Flutter localization code

```bash
flutter gen-l10n
```

Then wire up your `MaterialApp`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('fr'),
    Locale('de'),
    Locale('pt'),
  ],
  home: MyHomePage(),
)
```

Replace hardcoded strings:

```dart
// Before
Text("Upload Complete")

// After
Text(AppLocalizations.of(context)!.uploadComplete)
```

**Done. Change your device language and watch your app translate itself.**

---

## ⚙️ How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    Your Flutter App                         │
│         lib/main.dart, lib/screens/*.dart, etc.             │
└──────────────────────┬──────────────────────────────────────┘
                       │  autolingo scan
                       ▼
┌─────────────────────────────────────────────────────────────┐
│               String Extraction Engine                      │
│  Regex scans all .dart files for:                           │
│  Text() · AppBar titles · Button labels                     │
│  Hints · Tooltips · SnackBars · Dialogs                     │
└──────────────────────┬──────────────────────────────────────┘
                       │  autolingo generate
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    ARB Generator                            │
│  Converts strings → camelCase keys                          │
│  Writes valid l10n/en.arb (Flutter standard format)         │
└──────────────────────┬──────────────────────────────────────┘
                       │  autolingo translate
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                 Lingo.dev AI Translation                    │
│  Reads en.arb → translates to es, hi, fr, de, pt           │
│  Writes one ARB file per language                           │
└──────────────────────┬──────────────────────────────────────┘
                       │  flutter gen-l10n
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              Localized Flutter App                          │
│  Standard AppLocalizations — works with any Flutter app     │
└─────────────────────────────────────────────────────────────┘
```

### What AutoLingo detects

| Widget / Property  | Example                                 |
| ------------------ | --------------------------------------- |
| `Text()`           | `Text("Upload Complete")`               |
| `AppBar` title     | `AppBar(title: Text("Settings"))`       |
| Button labels      | `ElevatedButton(child: Text("Submit"))` |
| `SnackBar` content | `SnackBar(content: Text("Saved!"))`     |
| Input hints        | `hintText: "Enter your email"`          |
| Input labels       | `labelText: "Password"`                 |
| Tooltips           | `tooltip: "Delete item"`                |
| Helper text        | `helperText: "Must be 8 characters"`    |

### What AutoLingo skips (intentionally)

```dart
Text("$userName")          // interpolated — needs manual handling
Text("CONSTANT_KEY")       // ALL_CAPS — likely not UI text
Text("assets/image.png")   // file paths
Text("12345")              // numbers
```

---

## 📖 CLI Reference

```
autolingo <command>

Commands:
  init        Create l10n.yaml and i18n.json config files
  scan        Dry run — list all detected UI strings
  generate    Write l10n/en.arb from scanned strings
  translate   Run Lingo.dev to produce translated ARB files

Options:
  --version   Print version number
  --help      Show help
```

### Full one-liner

```bash
autolingo init && autolingo generate && autolingo translate && flutter gen-l10n
```

---

## 🗂️ Project Structure

```
autolingo/
├── bin/
│   └── autolingo.dart          ← CLI entry point (arg parsing, routing)
├── lib/
│   └── src/
│       ├── extractor.dart      ← Regex-based string scanner
│       ├── arb_generator.dart  ← Writes app_en.arb
│       ├── lingo_runner.dart   ← Shells out to npx lingo.dev run
│       └── init_command.dart   ← Scaffolds l10n.yaml + i18n.json
├── pubspec.yaml
└── README.md
```

---

## 🌍 Supported Languages

AutoLingo works with any language Lingo.dev supports — 60+. Default config includes:

| Code | Language | Code | Language   |
| ---- | -------- | ---- | ---------- |
| `es` | Spanish  | `pt` | Portuguese |
| `hi` | Hindi    | `ja` | Japanese   |
| `fr` | French   | `ko` | Korean     |
| `de` | German   | `ar` | Arabic     |
| `zh` | Chinese  | `ru` | Russian    |

Add more in `i18n.json`:

```json
"targets": ["es", "hi", "fr", "de", "pt", "ja", "ko", "ar", "zh", "ru"]
```

---

## 🎬 Demo

> _Watch AutoLingo localize a full Flutter app in under 60 seconds_

1. App launches in **English** (hardcoded strings)
2. `autolingo init && autolingo generate && autolingo translate`
3. `flutter gen-l10n`
4. Change device language to **Spanish** → UI updates instantly
5. Change to **Hindi** → UI updates instantly
6. No code changes in the Flutter app itself

---

## 🆚 AutoLingo vs Manual Localization

|                            | Manual                 | AutoLingo                   |
| -------------------------- | ---------------------- | --------------------------- |
| Setup time                 | 2–4 hours              | 5 minutes                   |
| ARB file creation          | Manual                 | Automatic                   |
| Translation                | Manual or paid service | Lingo.dev AI                |
| Keeps up with UI changes   | Manual re-sync         | Re-run `autolingo generate` |
| Works with existing apps   | Yes (painful)          | Yes (painless)              |
| Flutter standard compliant | Yes                    | Yes                         |
| Requires code changes      | Yes                    | Minimal                     |

---

## 🗺️ Roadmap

### MVP (current)

- [x] Regex-based string extraction
- [x] ARB file generation
- [x] Lingo.dev CLI integration
- [x] `init`, `scan`, `generate`, `translate` commands

### v0.2 — Coming soon

- [ ] `autolingo watch` — re-scan on file save
- [ ] Merge mode — preserve existing translations, only add new strings
- [ ] Ignore list — skip specific strings via comments `// autolingo-ignore`
- [ ] String interpolation support (`{name}` → ARB placeholders)

### v0.3 — Future

- [ ] GitHub Action for CI/CD translation pipeline
- [ ] Dart analyzer / AST-based extraction (more accurate than regex)
- [ ] `autolingo status` — show which strings are missing translations
- [ ] VS Code extension

---

## 🤝 Contributing

Contributions are welcome. AutoLingo is intentionally small — the core extraction engine is under 100 lines of Dart.

```bash
git clone https://github.com/KhushneetSingh/autolingo
cd autolingo
dart pub get
dart run bin/autolingo.dart scan  # test against any Flutter project
```

Areas that need help:

- More widget pattern coverage in `extractor.dart`
- Edge case handling in `arb_generator.dart`
- Tests (`test/` directory is empty — first PR wins)
- Support for other localization providers beyond Lingo.dev

---

## 📄 License

MIT — see [LICENSE](LICENSE)

---

<div align="center">

Built with ❤️ at **Hackathon 2026**

Powered by [Lingo.dev](https://lingo.dev) — open-source AI-powered i18n

[⭐ Star this repo](https://github.com/KhushneetSingh/autolingo) · [🐛 Report a bug](https://github.com/KhushneetSingh/autolingo/issues)

</div>
