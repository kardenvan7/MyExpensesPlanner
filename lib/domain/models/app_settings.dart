import 'package:flutter/material.dart';

class AppSettings {
  AppSettings({
    this.locale,
    this.primaryColor,
    this.secondaryColor,
    this.themeMode,
  });

  final Locale? locale;
  final Color? primaryColor;
  final Color? secondaryColor;
  final ThemeMode? themeMode;
}
