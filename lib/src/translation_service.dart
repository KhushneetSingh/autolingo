import 'dart:async';
import 'package:flutter/foundation.dart';
// ignore: unused_import — will be needed when the live Lingo endpoint is restored
import 'package:http/http.dart' as http;
import 'translation_cache.dart';

/// Prefix used for all [AutoLingo] console logs.
const _kLogPrefix = '[AutoLingo]';

/// Default timeout for every API request.
const _kRequestTimeout = Duration(seconds: 3);

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
        await _cache.set(text, targetLanguage, result);
        return result;
      }
      // result was null — log and fall through to original text
      debugPrint('$_kLogPrefix Translation returned null for "$text" → $targetLanguage');
    } on TimeoutException catch (e) {
      debugPrint('$_kLogPrefix Request timed out after ${_kRequestTimeout.inSeconds}s for "$text": $e');
    } catch (e, stack) {
      debugPrint('$_kLogPrefix Unexpected error translating "$text" → $targetLanguage: $e\n$stack');
    }

    // Silently return original text on any failure — no crashes.
    return text;
  }

  Future<String?> _performRequest(String text, String targetLanguage) async {
    // NOTE: The live Lingo HTTP endpoint is currently returning 404,
    // so we mock translations locally for the demo. When the endpoint
    // is healthy, swap the block below with a real http.post() call,
    // wrapped with .timeout(_kRequestTimeout) e.g.:
    //
    //   final response = await http.post(
    //     Uri.parse('https://api.lingo.dev/v1/translate'),
    //     headers: {'Authorization': 'Bearer $apiKey', ...},
    //     body: ...,
    //   ).timeout(_kRequestTimeout);
    //
    await Future.delayed(const Duration(milliseconds: 500))
        .timeout(_kRequestTimeout);

    if (targetLanguage == 'es') {
      if (text.contains('CARING FOR')) return 'CUIDANDO A';
      if (text.contains('Recent Clinical Notes')) return 'Notas Clínicas Recientes';
      if (text.contains("Today's Summary")) return 'Resumen de Hoy';
      if (text.contains('Great!!')) return '¡¡Genial!!';
      if (text.contains('Moderate Risk')) return 'Riesgo Moderado';
      return '[ES] $text';
    }

    return '[$targetLanguage] $text';
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
