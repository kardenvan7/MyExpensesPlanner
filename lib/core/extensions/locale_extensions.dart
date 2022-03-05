import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

extension LocaleExt on Locale {
  bool get isRussian {
    return toLangString() == SupportedLocales.russian.toLangString();
  }

  bool get isEnglish {
    return toLangString() == SupportedLocales.english.toLangString();
  }
}

extension LocaleFactory on Locale {
  String toLangString() {
    return '${languageCode}_$countryCode';
  }

  static Locale? fromLangString(String _langString) {
    final List<String> _localeComponents = _langString.split('_');

    if (_localeComponents.length < 2) {
      return null;
    }

    return Locale(
      _localeComponents[0],
      _localeComponents[1],
    );
  }

  /// Other
}
