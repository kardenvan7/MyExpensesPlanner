import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfiguredEasyLocalization extends StatelessWidget {
  const ConfiguredEasyLocalization({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: _LocalizationsConfig.pathToLocalizations,
      supportedLocales: _LocalizationsConfig.supportedLocalizations,
      fallbackLocale: _LocalizationsConfig.defaultLocale,
      // useOnlyLangCode: true,
      child: child,
    );
  }
}

class _LocalizationsConfig {
  static const String pathToLocalizations = 'assets/translations';
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
