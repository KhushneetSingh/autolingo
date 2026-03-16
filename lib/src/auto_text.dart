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
  bool _isTranslating = false;

  // We'll use a mocked API key for now if the TranslationService isn't passed down
  // In a real implementation this should be injected or accessed via InheritedWidget/Provider.
  // For the sake of this component, we'll instantiate a placeholder.
  late TranslationService _translationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the service from our provider
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
      _translateIfNeeded();
    }
  }

  Future<void> _translateIfNeeded() async {
    // Only run when we have access to context (to check locale)
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
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isTranslating) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.data, // Shows original text while translating
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
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    return Text(
      _displayText,
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
}
