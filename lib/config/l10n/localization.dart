import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_expenses_planner/main.dart';

class AppLocalizationsWrapper {
  AppLocalizationsWrapper();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static AppLocalizations ofGlobalContext() {
    return AppLocalizations.of(NavigatorService.key.currentContext!)!;
  }
}

class SupportedLocales {
  static const Locale russian = Locale('ru', 'RU');
  static const Locale english = Locale('en', 'GB');
}
