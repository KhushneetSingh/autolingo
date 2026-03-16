import 'dart:io';

/// Zero-dependency ANSI styling helpers for the AutoLingo CLI.
///
/// Uses raw escape codes so no external package is needed.
class Ansi {
  Ansi._();

  // ── ANSI escape sequences ──────────────────────────────────────────────────
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _dim = '\x1B[2m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';

  // ── Inline formatters (return styled strings) ──────────────────────────────
  static String green(String msg) => '$_green$msg$_reset';
  static String yellow(String msg) => '$_yellow$msg$_reset';
  static String red(String msg) => '$_red$msg$_reset';
  static String cyan(String msg) => '$_cyan$msg$_reset';
  static String bold(String msg) => '$_bold$msg$_reset';
  static String dim(String msg) => '$_dim$msg$_reset';
  static String greenBold(String msg) => '$_green$_bold$msg$_reset';
  static String yellowBold(String msg) => '$_yellow$_bold$msg$_reset';
  static String redBold(String msg) => '$_red$_bold$msg$_reset';

  // ── Print helpers ──────────────────────────────────────────────────────────
  /// Prints a branded header block.
  ///
  /// Example:
  /// ```
  ///   AutoLingo — string scanner
  /// ```
  static void header(String title, [String? subtitle]) {
    stdout.writeln('');
    stdout.writeln('  ${bold(title)}${subtitle != null ? ' ${dim('— $subtitle')}' : ''}');
  }

  /// Green ✓ success message.
  static void success(String msg) => stdout.writeln('  ${green('✓')} $msg');

  /// Yellow ● info / progress message.
  static void info(String msg) => stdout.writeln('  ${yellow('●')} $msg');

  /// Red ✗ error message (to stderr).
  static void error(String msg) => stderr.writeln('  ${red('✗')} $msg');

  /// Dimmed bullet list item.
  static void bullet(String msg) => stdout.writeln('    ${dim('•')} $msg');

  /// Hint line — dimmed instruction text.
  static void hint(String msg) => stdout.writeln('\n  ${dim(msg)}');

  /// Blank line.
  static void gap() => stdout.writeln('');
}
