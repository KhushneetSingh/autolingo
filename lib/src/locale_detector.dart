import 'dart:ui' as ui;

class LocaleDetector {
  String getDeviceLocale() {
    return ui.PlatformDispatcher.instance.locale.languageCode;
  }
}
