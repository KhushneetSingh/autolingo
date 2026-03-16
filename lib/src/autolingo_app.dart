import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translation_service.dart';

/// An InheritedWidget that holds the [TranslationService] and [debugMode] flag
/// for the descendant widget tree.
class AutoLingoProvider extends InheritedWidget {
  final TranslationService translationService;

  /// When true, [AutoText] widgets that have not yet received a translation
  /// will be highlighted in yellow for easy identification during development.
  final bool debugMode;

  const AutoLingoProvider({
    super.key,
    required this.translationService,
    required this.debugMode,
    required super.child,
  });

  /// Allows descendant widgets to access the [TranslationService].
  static TranslationService of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AutoLingoProvider>();
    if (provider == null) {
      throw FlutterError(
          'AutoLingoProvider.of() called with a context that does not contain an AutoLingoProvider.');
    }
    return provider.translationService;
  }

  /// Returns whether debug mode is enabled. Returns false if no provider found.
  static bool isDebugMode(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AutoLingoProvider>();
    return provider?.debugMode ?? false;
  }

  @override
  bool updateShouldNotify(AutoLingoProvider oldWidget) {
    return translationService != oldWidget.translationService ||
        debugMode != oldWidget.debugMode;
  }
}

/// A wrapper widget that initializes translation services and configures localization for the app.
class AutoLingoApp extends StatefulWidget {
  final Widget child;
  final String apiKey;
  final List<String> supportedLanguages;

  /// When set to `true`, [AutoText] widgets that are still showing the original
  /// (untranslated) string will be highlighted with a yellow background,
  /// making it easy to spot missing translations during development.
  ///
  /// Defaults to `false`. Do **not** enable in production builds.
  final bool debugMode;

  const AutoLingoApp({
    super.key,
    required this.apiKey,
    required this.supportedLanguages,
    required this.child,
    this.debugMode = false,
  });

  /// Exposes the [TranslationService] to the widget tree.
  static TranslationService of(BuildContext context) {
    return AutoLingoProvider.of(context);
  }

  /// Helper to get the required localization delegates for MaterialApp/CupertinoApp.
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates {
    return const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  /// Helper to get generic [Locale] objects from language code strings.
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
    if (oldWidget.apiKey != widget.apiKey) {
      _translationService = TranslationService(widget.apiKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoLingoProvider(
      translationService: _translationService,
      debugMode: widget.debugMode,
      child: widget.child,
    );
  }
}
