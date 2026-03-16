import 'package:flutter/widgets.dart';

class LocaleDetector {
  /// Gets the language code (e.g., 'en', 'es') from the context.
  /// Returns 'en' as a fallback if the context doesn't contain localizations.
  static String getLanguageCode(BuildContext context) {
    // maybeLocaleOf safely returns null instead of throwing an exception
    // if there's no Localizations widget in the ancestor tree.
    final locale = Localizations.maybeLocaleOf(context);
    return locale?.languageCode ?? 'en';
  }

  /// Determines if translation is needed based on the current locale.
  /// Returns false if the language code is 'en', true otherwise.
  static bool shouldTranslate(BuildContext context) {
    final languageCode = getLanguageCode(context);
    return languageCode.toLowerCase() != 'en';
  }

  /// Gets the full locale string (e.g., 'es-MX') from the context.
  /// Returns 'en' if localizations are unavailable.
  static String getFullLocale(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context);
    if (locale == null) {
      return 'en';
    }

    // Add country code if it exists
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}-${locale.countryCode}';
    }

    // Otherwise just return the language code
    return locale.languageCode;
  }
}
