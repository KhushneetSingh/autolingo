import 'dart:io';

/// Scans all Dart source files under [dirPath] and extracts UI-facing strings.
///
/// Returns a deduplicated, sorted [List<String>] of strings that are likely
/// user-visible text — suitable for internationalisation / ARB generation.
Future<List<String>> extractStrings(String dirPath) async {
  final dir = Directory(dirPath);

  if (!dir.existsSync()) {
    throw ArgumentError('Directory does not exist: $dirPath');
  }

  // Using a Set for automatic deduplication.
  final foundStrings = <String>{};

  // Collect all .dart files recursively.
  final dartFiles = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    final extracted = _extractFromSource(content);


    foundStrings.addAll(extracted);
  }



  return foundStrings.toList()..sort();
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

/// All regex patterns used to locate UI strings in Dart source code.
///
/// Each pattern captures the string value in group 1.
final List<RegExp> _patterns = [
  // Text("...") / Text('...')
  RegExp(r'''Text\(\s*["']([^"']+)["']'''),

  // title: "..." / title: '...'
  RegExp(r'''title\s*:\s*["']([^"']+)["']'''),

  // labelText: "..." / '...'
  RegExp(r'''labelText\s*:\s*["']([^"']+)["']'''),

  // hintText: "..." / '...'
  RegExp(r'''hintText\s*:\s*["']([^"']+)["']'''),

  // tooltip: "..." / '...'
  RegExp(r'''tooltip\s*:\s*["']([^"']+)["']'''),

  // helperText: "..." / '...'
  RegExp(r'''helperText\s*:\s*["']([^"']+)["']'''),

  // errorText: "..." / '...'
  RegExp(r'''errorText\s*:\s*["']([^"']+)["']'''),

  // SnackBar(content: Text("..."))
  RegExp(r'''SnackBar\s*\([^)]*content\s*:\s*Text\(\s*["']([^"']+)["']'''),

  // ElevatedButton / TextButton — child: Text("...")
  RegExp(
    r'''(?:ElevatedButton|TextButton)\s*\([^)]*child\s*:\s*Text\(\s*["']([^"']+)["']''',
  ),
];

/// Runs all [_patterns] against [source] and returns the matched strings,
/// already filtered through [_shouldSkip].
List<String> _extractFromSource(String source) {
  final results = <String>{};

  for (final pattern in _patterns) {
    for (final match in pattern.allMatches(source)) {
      final value = match.group(1);
      if (value != null && !_shouldSkip(value)) {
        results.add(value.trim());
      }
    }
  }

  return results.toList();
}

/// Returns `true` when [s] should be excluded from the output.
///
/// Filters out:
/// - Strings shorter than 2 characters
/// - Strings containing `$` (Dart string interpolation)
/// - ALL_CAPS_CONSTANTS (e.g. `MY_CONSTANT`)
/// - File-path-like strings (contain `.dart`, `.png`, or `/`)
/// - Pure numeric strings
bool _shouldSkip(String s) {
  // Too short to be meaningful UI text.
  if (s.length < 2) return true;

  // Contains string interpolation — runtime value, not static text.
  if (s.contains(r'$')) return true;

  // ALL_CAPS_CONSTANT pattern: only uppercase letters, digits, and underscores.
  if (RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(s)) return true;

  // Looks like a file path or asset reference.
  if (s.contains('.dart') || s.contains('.png') || s.contains('/')) {
    return true;
  }

  // Pure number (integer or decimal).
  if (RegExp(r'^\d+(\.\d+)?$').hasMatch(s)) return true;

  return false;
}
