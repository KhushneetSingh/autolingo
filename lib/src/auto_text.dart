import 'package:flutter/material.dart';
import 'locale_detector.dart';
import 'autolingo_app.dart';
import 'translation_service.dart';

class AutoText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const AutoText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  State<AutoText> createState() => _AutoTextState();
}

class _AutoTextState extends State<AutoText> {
  late String _displayText;

  /// True while a translation request is in-flight.
  bool _isTranslating = false;

  /// True once a successful translation has been stored in [_displayText].
  /// Used by debug mode to decide whether to show the yellow highlight.
  bool _isTranslated = false;

  late TranslationService _translationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translationService = AutoLingoProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    _displayText = widget.data;
    _translateIfNeeded();
  }

  @override
  void didUpdateWidget(AutoText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _displayText = widget.data;
      _isTranslated = false;
      _translateIfNeeded();
    }
  }

  Future<void> _translateIfNeeded() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      if (LocaleDetector.shouldTranslate(context)) {
        setState(() {
          _isTranslating = true;
        });

        final targetLocale = LocaleDetector.getLanguageCode(context);
        final translatedText =
            await _translationService.translate(widget.data, targetLocale);

        if (mounted) {
          setState(() {
            _displayText = translatedText;
            _isTranslating = false;
            // Mark as translated only when the result differs from the source.
            _isTranslated = translatedText != widget.data;
          });
        }
      }
    });
  }

  /// Builds a [Text] widget with all the forwarded parameters.
  Widget _buildText(String text) {
    return Text(
      text,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final debugMode = AutoLingoProvider.isDebugMode(context);

    if (_isTranslating) {
      // Show original text + a small spinner while waiting for the API.
      final loadingContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildText(widget.data),
          const SizedBox(width: 8),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );

      // In debug mode wrap with yellow highlight even while loading.
      if (debugMode) {
        return ColoredBox(
          color: Colors.yellow.withOpacity(0.4),
          child: loadingContent,
        );
      }
      return loadingContent;
    }

    final textWidget = _buildText(_displayText);

    // In debug mode, highlight strings that are still showing the original
    // English (i.e. translation was skipped or failed silently).
    if (debugMode && !_isTranslated && LocaleDetector.shouldTranslate(context)) {
      return ColoredBox(
        color: Colors.yellow.withOpacity(0.4),
        child: textWidget,
      );
    }

    return textWidget;
  }
}
