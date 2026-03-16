import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:autolingo/autolingo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Ensure we can use platform channels and shared preferences in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleDetector Tests', () {
    testWidgets('Returns default "en" when no localizations available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final locale = LocaleDetector.getLanguageCode(context);
            expect(locale, 'en');

            final shouldTranslate = LocaleDetector.shouldTranslate(context);
            expect(shouldTranslate, false);

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Detects Spanish locale correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Localizations(
          locale: const Locale('es', 'MX'),
          delegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate
          ],
          child: Builder(
            builder: (context) {
              final locale = LocaleDetector.getLanguageCode(context);
              expect(locale, 'es');

              final fullLocale = LocaleDetector.getFullLocale(context);
              expect(fullLocale, 'es-MX');

              final shouldTranslate = LocaleDetector.shouldTranslate(context);
              expect(shouldTranslate, true);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TranslationCache Tests', () {
    setUp(() {
      // Mock SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});
    });

    test('Stores and retrieves translations correctly', () async {
      final cache = TranslationCache.instance;

      // Initially, cache should be empty
      var result = await cache.get('Hello', 'es');
      expect(result, isNull);

      // Store a translation
      await cache.set('Hello', 'es', 'Hola');

      // Retrieve the translation
      result = await cache.get('Hello', 'es');
      expect(result, 'Hola');

      // Verify the has() method
      final hasTranslation = await cache.has('Hello', 'es');
      expect(hasTranslation, isTrue);
    });
  });
}
