import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';

class ConfiguredEasyLocalization extends StatelessWidget {
  const ConfiguredEasyLocalization({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: EasyLocalizationsConfig.pathToLocalizations,
      supportedLocales: EasyLocalizationsConfig.supportedLocalizations,
      fallbackLocale: EasyLocalizationsConfig.defaultLocale,
      // useOnlyLangCode: true,
      child: child,
    );
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
