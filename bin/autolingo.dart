import 'dart:io';

import 'package:args/args.dart';
import 'package:autolingo/src/arb_generator.dart';
import 'package:autolingo/src/cli_style.dart';
import 'package:autolingo/src/extractor.dart';
import 'package:autolingo/src/init_command.dart';
import 'package:autolingo/src/lingo_runner.dart';

const _version = '0.1.3';
const _scanDir = './lib';
const _arbOutput = './l10n/app_en.arb';

Future<void> main(List<String> arguments) async {
  // ---------------------------------------------------------------------------
  // Top-level arg parser (handles --version / --help)
  // ---------------------------------------------------------------------------
  final parser = ArgParser()
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Print version.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help.')
    ..addCommand('init')
    ..addCommand('scan')
    ..addCommand('generate')
    ..addCommand('translate');

  final ArgResults args;
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    Ansi.error(e.message);
    _printHelp();
    exit(1);
  }

  // --version flag
  if (args['version'] as bool) {
    print('  ${Ansi.bold('autolingo')} ${Ansi.dim('v$_version')}');
    return;
  }

  // --help flag
  if (args['help'] as bool) {
    _printHelp();
    return;
  }

  // Dispatch to subcommand
  switch (args.command?.name) {
    case 'init':
      await _handleInit();
    case 'scan':
      await _handleScan();
    case 'generate':
      await _handleGenerate();
    case 'translate':
      await _handleTranslate();
    default:
      _printHelp();
  }
}

// -----------------------------------------------------------------------------
// Subcommand handlers
// -----------------------------------------------------------------------------

/// `autolingo init` — scaffold l10n/ and config files.
Future<void> _handleInit() async {
  await runInit();
}

/// `autolingo scan` — extract and list UI strings found in ./lib.
Future<void> _handleScan() async {
  Ansi.header('AutoLingo', 'string scanner');
  Ansi.info('Scanning ${Ansi.bold(_scanDir)}...');

  final strings = await extractStrings(_scanDir);

  Ansi.gap();
  print('  Found ${Ansi.greenBold(strings.length.toString())} UI strings:');
  Ansi.gap();
  for (final s in strings) {
    Ansi.bullet(s);
  }

  Ansi.hint("Run ${Ansi.yellow("'autolingo generate'")} to create your ARB file.");
  Ansi.gap();
}

/// `autolingo generate` — extract strings and write ./l10n/app_en.arb.
Future<void> _handleGenerate() async {
  Ansi.header('AutoLingo', 'ARB generator');
  Ansi.info('Generating ARB file...');

  final strings = await extractStrings(_scanDir);

  if (strings.isEmpty) {
    Ansi.error('No strings found in $_scanDir. Nothing to generate.');
    return;
  }

  await generateArb(strings, outputPath: _arbOutput);

  Ansi.success(
    'Written: ${Ansi.bold(_arbOutput)} '
    '(${Ansi.greenBold(strings.length.toString())} strings)',
  );
  Ansi.hint("Next step: ${Ansi.yellow("'autolingo translate'")}");
  Ansi.gap();
}

/// `autolingo translate` — run Lingo.dev (requires app_en.arb to exist first).
Future<void> _handleTranslate() async {
  if (!File(_arbOutput).existsSync()) {
    Ansi.error(
      '"$_arbOutput" not found.\n'
      "  Run ${Ansi.yellow("'autolingo generate'")} first to create the source ARB file.",
    );
    exit(1);
  }

  await runLingoTranslate();
}

// -----------------------------------------------------------------------------
// Help
// -----------------------------------------------------------------------------

void _printHelp() {
  print('''

  ${Ansi.bold('autolingo')} ${Ansi.dim('v$_version')} — Zero-config Flutter i18n CLI

  ${Ansi.bold('USAGE')}
    autolingo <command> [options]

  ${Ansi.bold('COMMANDS')}
    ${Ansi.green('init')}        Scaffold l10n/ directory and config files
    ${Ansi.green('scan')}        Scan ./lib for UI strings and preview them
    ${Ansi.green('generate')}    Extract UI strings and write l10n/app_en.arb
    ${Ansi.green('translate')}   Push app_en.arb to Lingo.dev for AI translation

  ${Ansi.bold('OPTIONS')}
    -v, --version   Print the current version
    -h, --help      Show this help message

  ${Ansi.bold('EXAMPLE WORKFLOW')}
    ${Ansi.dim('\$')} autolingo init
    ${Ansi.dim('\$')} autolingo generate
    ${Ansi.dim('\$')} autolingo translate
''');
}
