import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLocalizationsWrapper {
  AppLocalizationsWrapper();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

class EasyLocalizationsConfig {
  static const String pathToLocalizations = 'assets/deprecated_translations';
  static const List<Locale> supportedLocalizations = <Locale>[
    SupportedLocales.english,
    SupportedLocales.russian,
  ];

  static const Locale defaultLocale = SupportedLocales.russian;
}

class SupportedLocales {
  static const Locale russian = Locale('ru', 'RU');
  static const Locale english = Locale('en', 'GB');
}
