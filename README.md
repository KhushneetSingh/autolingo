<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# AutoLingo

AutoLingo is a Flutter package that provides seamless, automatic text translation for your applications. It acts as a wrapper around translation services, handling locale detection and UI updates automatically.

## Features

- **Automatic Locale Detection**: Detects the user's system language and updates the UI.
- **AutoText Widget**: A drop-in replacement for the standard `Text` widget with translation support.
- **Easy Integration**: Wrap your app with `AutoLingoApp` and you're ready to go.

## Getting Started

Add `autolingo` to your `pubspec.yaml` and run `flutter pub get`.

```yaml
dependencies:
  autolingo:
    path: ./path/to/autolingo
```

## Usage

Wrap your `MaterialApp` with `AutoLingoApp` and provide your API key.

```dart
AutoLingoApp(
  apiKey: 'YOUR_API_KEY',
  supportedLanguages: ['en', 'es', 'hi', 'fr', 'de'],
  child: MyApp(),
)
```

Use `AutoText` instead of `Text` for strings that should be translated.

```dart
AutoText('Hello World')
```

## Environment Variables

> [!IMPORTANT]
> The `.env` file included in this repository is for **testing and demonstration purposes only**. 
> When using this package in your own application, you should provide your own `apiKey` to the `AutoLingoApp` widget. 

## Additional Information

For more information on how to use the package, refer to the documentation at [lingo.dev](https://lingo.dev).
