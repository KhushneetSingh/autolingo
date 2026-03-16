<div align="center">

```
  ___         _        _     _
 / _ \       | |      | |   (_)
/ /_\ \_   _ | |_ ___ | |    _ _ __   __ _  ___
|  _  | | | || __/ _ \| |   | | '_ \ / _` |/ _ \
| | | | |_| || || (_) | |___| | | | | (_| | (_) |
\_| |_/\__,_| \__\___/\_____/_|_| |_|\__, |\___/
                                       __/ |
                                      |___/
```

### _"The missing link in Flutter localization"_

**🏆 Hackathon Project · Built with [Lingo.dev](https://lingo.dev)**

[![pub package](https://img.shields.io/pub/v/autolingo.svg)](https://pub.dev/packages/autolingo)

</div>

---

## 💡 The Idea

> **90% of Flutter apps are English-only — not because developers don't want to localize, but because the setup is too painful.**

AutoLingo was built in 48 hours to solve exactly that.

It's a **Dart CLI tool** that reads your existing Flutter app, extracts every UI string automatically, and hands them to Lingo.dev for AI-powered translation — all with three terminal commands.

---

## ⚡ Quick Demo

```
$ cd my_flutter_app
$ autolingo init && autolingo generate && autolingo translate

AutoLingo — string scanner
Scanning ./lib...
Found 34 UI strings ✓

Generating l10n/en.arb... ✓
Running Lingo.dev translation...
✔ Translated to Spanish  →  l10n/es.arb
✔ Translated to Hindi    →  l10n/hi.arb
✔ Translated to French   →  l10n/fr.arb
✔ Translated to German   →  l10n/de.arb

Translation complete in 28 seconds.
```

**Change your device language. Your app follows.**

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────┐
│               Existing Flutter App                   │
│     Text() · AppBar · Buttons · Hints · Dialogs      │
└──────────────────┬───────────────────────────────────┘
                   │
         autolingo scan / generate
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│            String Extraction Engine                  │
│   Regex scans all .dart files recursively            │
│   Deduplicates · Filters junk · Sorts output         │
└──────────────────┬───────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│              ARB File Generator                      │
│   "Upload Complete" → uploadComplete                 │
│   Writes valid l10n/en.arb (Flutter standard)        │
└──────────────────┬───────────────────────────────────┘
                   │
         autolingo translate
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│           Lingo.dev AI Translation Layer             │
│   en.arb → es.arb, hi.arb, fr.arb, de.arb ...       │
│   AI-powered · Translation memory · Brand voice      │
└──────────────────┬───────────────────────────────────┘
                   │
           flutter gen-l10n
                   │
                   ▼
┌──────────────────────────────────────────────────────┐
│           Standard Flutter Localization              │
│   AppLocalizations.of(context)!.uploadComplete       │
│   Works with any Flutter app, any version            │
└──────────────────────────────────────────────────────┘
```

---

## 🛠️ Install & Run

> 📦 **Available on [pub.dev →](https://pub.dev/packages/autolingo)**

```bash
# Install from pub.dev
dart pub global activate autolingo

# Inside any Flutter project
autolingo init       # creates l10n.yaml + i18n.json
autolingo scan       # preview what strings will be extracted
autolingo generate   # writes l10n/en.arb
autolingo translate  # calls Lingo.dev, writes translated ARBs
```

Requires: Dart 3.0+, Flutter 3.x, Node.js, [Lingo.dev account](https://lingo.dev) (free)

---

## 📦 What Gets Extracted

AutoLingo's regex engine catches the most common Flutter UI patterns:

| Pattern                          | Catches                |
| -------------------------------- | ---------------------- |
| `Text("...")`                    | All basic text widgets |
| `AppBar(title: Text("..."))`     | Screen titles          |
| `*Button(child: Text("..."))`    | All button variants    |
| `SnackBar(content: Text("..."))` | Notifications          |
| `hintText: "..."`                | Input placeholders     |
| `labelText: "..."`               | Form labels            |
| `tooltip: "..."`                 | Accessibility labels   |
| `helperText: "..."`              | Form helper text       |

Strings with `$interpolation`, `CONSTANTS`, file paths, and numbers are automatically skipped.

---

## 🎯 Hackathon Insights

**The hardest part wasn't the code — it was the insight.**

Flutter's localization system is actually great. The problem is the _workflow_ to get there. Nobody was solving the "how do I generate ARB files from existing code" problem. Lingo.dev solves the translation problem beautifully. AutoLingo is the bridge.

**What we learned:**

- Regex gets you 90% of real-world Flutter string extraction with 20 lines of code
- `Process.run()` to shell out to existing CLIs is underrated for hackathon tools
- The best tools are ones that disappear — AutoLingo produces standard Flutter output, so devs aren't locked in

---

## 🗺️ Roadmap

- `autolingo watch` — hot-reload style re-scanning on file save
- Merge mode — preserve existing translations, add only new strings
- `// autolingo-ignore` comment support
- ARB placeholder support for `$variable` strings
- GitHub Action for automated localization in CI/CD

---

## 🤝 Contribute

```bash
git clone https://github.com/KhushneetSingh/autolingo
cd autolingo
dart pub get

# Test against any Flutter project
dart run bin/autolingo.dart scan --dir path/to/flutter/app
```

The codebase is tiny and intentionally readable. `extractor.dart` is the interesting bit.

---

<div align="center">

**Built in 48 hours at Hackathon 2026**

Extraction → ARB → Translation → Done

[📦 pub.dev](https://pub.dev/packages/autolingo) · [GitHub](https://github.com/KhushneetSingh/autolingo) · [Lingo.dev](https://lingo.dev) · MIT License

_If this saved you time, leave a ⭐_

</div>
