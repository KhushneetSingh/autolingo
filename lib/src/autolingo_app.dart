import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translation_service.dart';

/// An InheritedWidget that holds the TranslationService for the descendant widget tree.
class AutoLingoProvider extends InheritedWidget {
  final TranslationService translationService;

  const AutoLingoProvider({
    super.key,
    required this.translationService,
    required super.child,
  });

  /// Allows descendant widgets to access the TranslationService.
  static TranslationService of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AutoLingoProvider>();
    if (provider == null) {
      throw FlutterError(
          'AutoLingoProvider.of() called with a context that does not contain an AutoLingoProvider.');
    }
    return provider.translationService;
  }

  @override
  bool updateShouldNotify(AutoLingoProvider oldWidget) {
    // Only notify if the service instance itself changes
    return translationService != oldWidget.translationService;
  }
}

/// A wrapper widget that initializes translation services and configures localization for the app.
class AutoLingoApp extends StatefulWidget {
  final Widget child;
  final String apiKey;
  final List<String> supportedLanguages;

  const AutoLingoApp({
    super.key,
    required this.apiKey,
    required this.supportedLanguages,
    required this.child,
  });

  /// Exposes the TranslationService to the widget tree
  static TranslationService of(BuildContext context) {
    return AutoLingoProvider.of(context);
  }

  /// Helper to get the required localization delegates for MaterialApp/CupertinoApp
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates {
    return const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  /// Helper to get generic Locale objects from language strings
  static Iterable<Locale> supportedLocales(List<String> languageCodes) {
    return languageCodes.map((code) => Locale(code));
  }

  @override
  State<AutoLingoApp> createState() => _AutoLingoAppState();
}

class _AutoLingoAppState extends State<AutoLingoApp> {
  late TranslationService _translationService;

  @override
  void initState() {
    super.initState();
    _translationService = TranslationService(widget.apiKey);
  }

  @override
  void didUpdateWidget(AutoLingoApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize service if API key changes
    if (oldWidget.apiKey != widget.apiKey) {
      _translationService = TranslationService(widget.apiKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoLingoProvider(
      translationService: _translationService,
      // Wrap the child with a builder to inject localizations if the user hasn't already done so
      // in their own MaterialApp/CupertinoApp. (AutoLingoApp should ideally wrap MaterialApp directly
      // or sit just above it).
      child: widget.child,
    );
  }
}
