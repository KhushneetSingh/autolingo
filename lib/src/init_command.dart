import 'dart:convert';
import 'dart:io';

/// Scaffolds the files needed to use AutoLingo + Lingo.dev in a Flutter project.
///
/// Creates the following (skipping any that already exist):
/// - `./l10n/`          — ARB output directory
/// - `./l10n.yaml`      — Flutter localisation config
/// - `./.lingo`         — Lingo.dev project config (JSON)
Future<void> runInit() async {
  // -------------------------------------------------------------------------
  // 1. Create the l10n/ directory
  // -------------------------------------------------------------------------
  final l10nDir = Directory('l10n');
  if (!l10nDir.existsSync()) {
    l10nDir.createSync(recursive: true);
    print('Created l10n/');
  } else {
    print('Skipped l10n/ (already exists)');
  }

  // -------------------------------------------------------------------------
  // 2. Write l10n.yaml (Flutter localisation configuration)
  // -------------------------------------------------------------------------
  const l10nYamlContent = '''arb-dir: l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''';

  await _writeIfAbsent('l10n.yaml', l10nYamlContent);

  // -------------------------------------------------------------------------
  // 3. Write .lingo (Lingo.dev project configuration)
  // -------------------------------------------------------------------------
  final lingoConfig = {
    'sourceLocale': 'en',
    'targetLocales': ['es', 'hi', 'fr', 'de', 'pt'],
    'files': {
      'flutter-arb': {
        'include': ['l10n/app_{locale}.arb'],
      },
    },
  };

  const encoder = JsonEncoder.withIndent('  ');
  await _writeIfAbsent('.lingo', encoder.convert(lingoConfig));

  // -------------------------------------------------------------------------
  // Done
  // -------------------------------------------------------------------------
  print('\nDone! Now run: autolingo generate');
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

/// Writes [content] to [path] only if the file does not already exist.
Future<void> _writeIfAbsent(String path, String content) async {
  final file = File(path);
  if (file.existsSync()) {
    print('Skipped $path (already exists)');
    return;
  }
  file.writeAsStringSync(content);
  print('Created $path');
}
