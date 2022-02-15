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
      path: LocalizationsConfig.pathToLocalizations,
      supportedLocales: LocalizationsConfig.supportedLocalizations,
      fallbackLocale: LocalizationsConfig.defaultLocale,
      // useOnlyLangCode: true,
      child: child,
    );
  }
}
