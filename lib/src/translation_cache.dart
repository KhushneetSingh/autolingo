import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationCache {
  // Static instance (singleton) for app-wide access
  static final TranslationCache _instance = TranslationCache._internal();

  /// Gets the singleton instance
  static TranslationCache get instance => _instance;

  // Factory constructor to return the singleton instance
  factory TranslationCache() {
    return _instance;
  }

  TranslationCache._internal();

  // Helper method to generate the cache key based on format: "autolingo_{languageCode}_{original}"
  String _generateKey(String original, String languageCode) {
    return 'autolingo_${languageCode}_$original';
  }

  /// Retrieves a cached translation
  Future<String?> get(String original, String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(original, languageCode);

      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString);
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('translated')) {
          return decoded['translated'] as String;
        }
      }
      return null;
    } catch (e) {
      // Catch all exceptions (SharedPreferences or JSON decoding errors) and return null
      return null;
    }
  }

  /// Caches a translation as JSON
  Future<void> set(
      String original, String languageCode, String translated) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(original, languageCode);

      final jsonString = jsonEncode({'translated': translated});
      await prefs.setString(key, jsonString);
    } catch (e) {
      // Silently fail on cache write errors to avoid crashing the app
    }
  }

  /// Checks if a translation exists in the cache
  Future<bool> has(String original, String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(original, languageCode);
      return prefs.containsKey(key);
    } catch (e) {
      // Return false if there's an error accessing SharedPreferences
      return false;
    }
  }
}
