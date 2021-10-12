import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class LocalizationsConfig {
  static const String pathToLocalizations = 'assets/translations';
  static const List<Locale> localeList = [
    Locales.english,
    Locales.russian,
  ];

  static const Locale defaultLocale = Locales.english;
}

class Locales {
  static const Locale russian = Locale('ru');
  static const Locale english = Locale('en');
}

class ConfiguredEasyLocalization extends StatelessWidget {
  const ConfiguredEasyLocalization({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: LocalizationsConfig.pathToLocalizations,
      supportedLocales: LocalizationsConfig.localeList,
      fallbackLocale: LocalizationsConfig.defaultLocale,
      useOnlyLangCode: true,
      child: child,
    );
  }
}
