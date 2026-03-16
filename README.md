# autolingo

**Drop-in Flutter widget that auto-translates your UI into the user's language — no backend changes needed.**

---

## Before / After

```dart
// Before — static text
Text('Welcome')

// After — auto-translated
AutoText('Welcome')   // renders in the user's system language
```

---

## Installation

```bash
flutter pub add autolingo
```

---

## Quick Start

Wrap your app once, then use `AutoText` anywhere:

```dart
AutoLingoApp(
  apiKey: 'YOUR_LINGO_API_KEY',
  supportedLanguages: const ['en', 'es', 'hi', 'fr', 'de'],
  child: MaterialApp(home: MyHomePage()),
)
```

---

## How It Works

- **Locale detection** — reads the device's system language at runtime.
- **Automatic translation** — sends strings to Lingo.dev when a non-English locale is detected.
- **Caching** — results are stored in `SharedPreferences`; repeated strings cost zero API calls.
- **Safe fallback** — on timeout or error, the original English text is shown silently (no crashes).
- **Debug mode** — pass `debugMode: true` to highlight untranslated strings in yellow.

---

## Supported Languages

| Code | Language |
|------|----------|
| `en` | English  |
| `es` | Spanish  |
| `hi` | Hindi    |
| `fr` | French   |
| `de` | German   |

Add any language supported by Lingo.dev by including its code in `supportedLanguages`.

---

[![Built at Hackathon](https://img.shields.io/badge/Built%20at%20Hackathon-Lingo.dev-blueviolet?style=flat-square)](https://lingo.dev)


