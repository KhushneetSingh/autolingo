import 'package:shared_preferences/shared_preferences.dart';

class TranslationCache {
  Future<void> cacheTranslation(String key, String translation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, translation);
  }

  Future<String?> getTranslation(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
