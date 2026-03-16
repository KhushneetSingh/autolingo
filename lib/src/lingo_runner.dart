import 'dart:io';

import 'package:autolingo/src/cli_style.dart';

/// Shells out to `npx lingo.dev run` and streams its output in real-time.
///
/// If the process exits with a non-zero code, stderr is printed and the
/// current Dart process terminates with exit code 1.
Future<void> runLingoTranslate() async {
  Ansi.header('AutoLingo', 'translator');
  Ansi.info('Running Lingo.dev translation...');
  Ansi.gap();

  // Use Process.start() so stdout/stderr can be streamed as they arrive,
  // giving the user live progress instead of waiting for the process to finish.
  final process = await Process.start(
    'npx',
    ['lingo.dev', 'run'],
    runInShell: true,
  );

  // Pipe the child process streams to this process's streams in real-time.
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    Ansi.gap();
    Ansi.error('Translation failed ${Ansi.dim('(exit code $exitCode)')}');
    exit(1);
  }

  Ansi.gap();
  Ansi.success('Translation complete! Check your ${Ansi.bold('l10n/')} folder.');
  Ansi.gap();
}
