// Pre-warms the translation cache so that the demo shows instant results
// with zero API delay.
//
// Run from the host app's directory (not from the package root) because
// SharedPreferences needs a running Flutter engine:
//
//   flutter run bin/prewarm.dart          (on a connected device / emulator)
//
// Or call [prewarmCache] programmatically from your app's startup code:
//
//   await prewarmCache('YOUR_API_KEY');

import 'package:flutter/widgets.dart';
import 'package:autolingo/autolingo.dart';

/// Strings to pre-translate for the demo.
// ignore: constant_identifier_names
const List<String> STRINGS = [
  'Upload Complete',
  'Welcome',
  'Submit',
  'Cancel',
  'Loading...',
  'Error',
  'Success',
  'Settings',
  'Profile',
  'Home',
];

/// Target languages to cache translations for.
const List<String> _targetLanguages = ['es', 'hi', 'fr'];

/// Pre-translates every string in [STRINGS] into all [_targetLanguages] and
/// stores the results in the local [TranslationCache].
///
/// [apiKey] is forwarded to [TranslationService].
Future<void> prewarmCache(String apiKey) async {
  final service = TranslationService(apiKey);
  final total = STRINGS.length * _targetLanguages.length;
  var done = 0;

  for (final text in STRINGS) {
    for (final lang in _targetLanguages) {
      await service.translate(text, lang);
      done++;
      // ignore: avoid_print
      print('[AutoLingo] Translated $done/$total strings...');
    }
  }

  // ignore: avoid_print
  print('[AutoLingo] ✅ Cache prewarm complete — $total translations cached.');
}

/// Entry-point when running via `flutter run bin/prewarm.dart`.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prewarmCache('DEMO_KEY');
}
