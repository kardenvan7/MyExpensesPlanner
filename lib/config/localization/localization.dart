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
      useOnlyLangCode: true,
      child: child,
    );
  }
}

class _LocalizationsConfig {
  static const String pathToLocalizations = 'assets/translations';
  static const List<Locale> supportedLocalizations = <Locale>[
    _SupportedLocales.english,
    _SupportedLocales.russian,
  ];

  static const Locale defaultLocale = _SupportedLocales.english;
}

class _SupportedLocales {
  static const Locale russian = Locale('ru');
  static const Locale english = Locale('en');
}
