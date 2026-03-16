import 'package:test/test.dart';
import 'package:autolingo/src/extractor.dart';

void main() {
  group('String Extractor', () {
    test('Extracts Text() strings', () {
      final source = '''
        Text("Upload Complete")
        Text('Welcome to Ace')
      ''';

      final results = extractFromSourceForTest(source);
      expect(results, containsAll(['Upload Complete', 'Welcome to Ace']));
    });

    test('Skips interpolated strings', () {
      final source = '''
        Text("\$userName logged in")
      ''';

      final results = extractFromSourceForTest(source);
      expect(results, isEmpty);
    });

    test('Skips ALL_CAPS constants', () {
      final source = '''
        Text("MY_CONSTANT")
      ''';

      final results = extractFromSourceForTest(source);
      expect(results, isEmpty);
    });

    test('Skips file paths', () {
      final source = '''
        Text("assets/image.png")
      ''';

      final results = extractFromSourceForTest(source);
      expect(results, isEmpty);
    });

    test('Extracts hintText and labelText', () {
      final source = '''
        hintText: "Enter email"
        labelText: 'Password'
      ''';

      final results = extractFromSourceForTest(source);
      expect(results, containsAll(['Enter email', 'Password']));
    });
  });
}
