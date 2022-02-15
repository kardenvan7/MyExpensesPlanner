import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/localization/localization.dart';

extension BuildContextExt on BuildContext {
  Future<void> switchLocale() async {
    if (isEnglishLocale) {
      await setLocale(SupportedLocales.russian);
    } else {
      await setLocale(SupportedLocales.english);
    }
  }

  bool get isRussianLocale {
    return locale.toStringWithSeparator() ==
        SupportedLocales.russian.toStringWithSeparator();
  }

  bool get isEnglishLocale {
    return locale.toStringWithSeparator() ==
        SupportedLocales.english.toStringWithSeparator();
  }
}
