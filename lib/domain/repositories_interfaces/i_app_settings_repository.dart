import 'package:flutter/material.dart';

abstract class IAppSettingsRepository {
  Future<void> saveAppLanguage(Locale locale);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<ThemeMode?> getTheme();
}
