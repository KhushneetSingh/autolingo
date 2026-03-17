import 'dart:convert';
import 'dart:io';

import 'package:autolingo/src/cli_style.dart';

/// Scaffolds the files needed to use AutoLingo + Lingo.dev in a Flutter project.
///
/// Creates the following (skipping any that already exist):
/// - `./l10n/`          — ARB output directory
/// - `./l10n.yaml`      — Flutter localisation config
/// - `./i18n.json`      — Lingo.dev project config (JSON)
Future<void> runInit() async {
  Ansi.header('AutoLingo', 'project setup');

  // -------------------------------------------------------------------------
  // 1. Create the l10n/ directory
  // -------------------------------------------------------------------------
  final l10nDir = Directory('l10n');
  if (!l10nDir.existsSync()) {
    l10nDir.createSync(recursive: true);
    Ansi.success('Created ${Ansi.bold('l10n/')}');
  } else {
    Ansi.info('Skipped ${Ansi.bold('l10n/')} ${Ansi.dim('(already exists)')}');
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
  // 3. Write i18n.json (Lingo.dev project configuration)
  // -------------------------------------------------------------------------
  final lingoConfig = {
    r'$schema': 'https://lingo.dev/schema/i18n.json',
    'version': '1.15',
    'locale': {
      'source': 'en',
      'targets': ['es', 'hi', 'fr', 'de', 'pt'],
    },
    'buckets': {
      'flutter': {
        'include': ['l10n/app_[locale].arb'],
      },
    },
  };

  const encoder = JsonEncoder.withIndent('  ');
  await _writeIfAbsent('i18n.json', encoder.convert(lingoConfig));

  // -------------------------------------------------------------------------
  // Done
  // -------------------------------------------------------------------------
  Ansi.hint("Now run: ${Ansi.yellow("'autolingo generate'")}");
  Ansi.gap();
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

/// Writes [content] to [path] only if the file does not already exist.
Future<void> _writeIfAbsent(String path, String content) async {
  final file = File(path);
  if (file.existsSync()) {
    Ansi.info('Skipped ${Ansi.bold(path)} ${Ansi.dim('(already exists)')}');
    return;
  }
  file.writeAsStringSync(content);
  Ansi.success('Created ${Ansi.bold(path)}');
}
