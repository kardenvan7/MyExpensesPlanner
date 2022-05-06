import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_expenses_planner/config/constants.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/presentation/ui/my_expenses_planner.dart';

class AppLocalizationsFacade {
  AppLocalizationsFacade();

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static AppLocalizations ofGlobalContext() {
    return AppLocalizations.of(NavigatorService.key.currentContext!)!;
  }

  static String getAppTitle(Locale locale) {
    if (locale.isEnglish) {
      return ConfigConstants.englishAppTitle;
    } else {
      return ConfigConstants.russianAppTitle;
    }
  }
}

class SupportedLocales {
  static const Locale russian = Locale('ru', 'RU');
  static const Locale english = Locale('en', 'GB');
}
