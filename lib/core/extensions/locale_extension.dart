import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

extension LocaleExt on Locale {
  bool get isRussian {
    return languageCode == SupportedLocales.russian.languageCode;
  }

  bool get isEnglish {
    return languageCode == SupportedLocales.english.languageCode;
  }
}
