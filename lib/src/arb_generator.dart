import 'dart:convert';
import 'dart:io';

/// Generates a Flutter ARB (Application Resource Bundle) file from [strings].
///
/// The resulting file is written to [outputPath] as pretty-printed JSON
/// compatible with Flutter's `flutter_localizations` tooling.
Future<void> generateArb(
  List<String> strings, {
  required String outputPath,
}) async {
  // -------------------------------------------------------------------------
  // Build the ARB map
  // -------------------------------------------------------------------------
  final arbMap = <String, dynamic>{
    // Required ARB locale marker — always the first key.
    '@@locale': 'en',
  };

  // Track keys that have already been used so we can suffix duplicates.
  final usedKeys = <String, int>{};

  for (final string in strings) {
    String key = _toArbKey(string, string.hashCode);

    // Handle duplicate keys: append an incrementing numeric suffix.
    if (usedKeys.containsKey(key)) {
      usedKeys[key] = usedKeys[key]! + 1;
      key = '$key${usedKeys[key]}';
    } else {
      usedKeys[key] = 0;
    }

    // The localised string value.
    arbMap[key] = string;

    // The companion metadata entry required by the ARB format.
    arbMap['@$key'] = {
      'description': 'Auto-extracted by AutoLingo',
    };
  }

  // -------------------------------------------------------------------------
  // Write to disk
  // -------------------------------------------------------------------------
  final outputFile = File(outputPath);

  // Ensure the output directory exists before writing.
  final outputDir = outputFile.parent;
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Flutter ARB files are standard JSON with 2-space indentation.
  final encoder = JsonEncoder.withIndent('  ');
  outputFile.writeAsStringSync(encoder.convert(arbMap));

  print('Generated $outputPath with ${strings.length} string(s)');
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

/// Converts a human-readable UI string into a lowerCamelCase ARB key.
///
/// Examples:
/// - `"Upload Complete"` → `"uploadComplete"`
/// - `"Are you sure?"` → `"areYouSure"`
/// - `""` / purely symbolic → `"key<hashCode>"`
///
/// [hashCode] is used as a fallback suffix when the cleaned result is empty.
String _toArbKey(String input, int hashCode) {
  // 1. Lowercase the entire string first.
  final lower = input.toLowerCase();

  // 2. Remove everything that is not a letter, digit, or space.
  final cleaned = lower.replaceAll(RegExp(r'[^a-z0-9 ]'), '');

  // 3. Split on whitespace and filter empty segments.
  final words = cleaned.split(' ').where((w) => w.isNotEmpty).toList();

  if (words.isEmpty) {
    // Fallback: use a generic key with the hash so it is still unique.
    return 'key${hashCode.abs()}';
  }

  // 4. Combine: keep the first word fully lowercase, then capitalise the rest.
  final buffer = StringBuffer(words.first);
  for (var i = 1; i < words.length; i++) {
    buffer.write(words[i][0].toUpperCase());
    if (words[i].length > 1) {
      buffer.write(words[i].substring(1));
    }
  }

  final result = buffer.toString();

  // Edge case: result could still be empty if input was e.g. "123".
  return result.isEmpty ? 'key${hashCode.abs()}' : result;
}
