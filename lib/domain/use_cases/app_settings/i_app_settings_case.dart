import 'package:flutter/material.dart';

abstract class IAppSettingsCase {
  Future<void> saveAppLanguage(Locale locale);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<ThemeMode?> getTheme();
}
