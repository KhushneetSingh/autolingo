import 'dart:io';

/// Shells out to `npx lingo.dev run` and streams its output in real-time.
///
/// If the process exits with a non-zero code, stderr is printed and the
/// current Dart process terminates with exit code 1.
Future<void> runLingoTranslate() async {
  print('Running Lingo.dev translation...');

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
    stderr.writeln('\nTranslation failed (exit code $exitCode).');
    exit(1);
  }

  print('\nTranslation complete! Check your l10n/ folder.');
}
