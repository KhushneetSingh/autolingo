import 'dart:convert';
import 'package:http/http.dart' as http;
import 'translation_cache.dart';

class TranslationService {
  final String apiKey;
  final TranslationCache _cache = TranslationCache.instance;

  TranslationService(this.apiKey);

  Future<String> translate(String text, String targetLanguage) async {
    // Check cache first
    final cachedTranslation = await _cache.get(text, targetLanguage);
    if (cachedTranslation != null) {
      return cachedTranslation;
    }

    try {
      final result = await _performRequest(text, targetLanguage);
      if (result != null) {
        // Store in cache
        await _cache.set(text, targetLanguage, result);
        return result;
      }
    } catch (e) {
      // Fallback on error
    }

    // Return original text if API fails (or if result was null)
    return text;
  }

  Future<String?> _performRequest(String text, String targetLanguage, {int retryCount = 0}) async {
    final url = Uri.parse('https://api.lingo.dev/v1/translate');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'text': text,
        'target': targetLanguage,
        'source': 'en',
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      
      // Parse response JSON and extract translated text
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('translation')) {
          return decoded['translation'].toString();
        }
        if (decoded.containsKey('translatedText')) {
          return decoded['translatedText'].toString();
        }
        if (decoded.containsKey('text')) {
          return decoded['text'].toString();
        }
        if (decoded.containsKey('result')) {
          return decoded['result'].toString();
        }
        if (decoded.containsKey('data')) {
          return decoded['data'].toString();
        }
      }
      return null;
    } else if (response.statusCode == 429 && retryCount < 1) { // Rate limited
      // Simple retry after 1 second
      await Future.delayed(const Duration(seconds: 1));
      return _performRequest(text, targetLanguage, retryCount: retryCount + 1);
    }
    
    // Any other failure
    return null;
  }
}

// Simple test, uncomment to run directly but make sure SharedPreferences runs on Android/iOS/Mac or run a mocked version.
// Using SharedPreferences in a pure Dart CLI will cause a MissingPluginException if not mocked.
// void main() async {
//   final service = TranslationService('TEST_API_KEY');
//   
//   print('Translating "Hello World" to "es"...');
//   try {
//     final result = await service.translate('Hello World', 'es');
//     print('Result: $result');
//   } catch (e) {
//     print('Exception during test: $e');
//   }
// }
