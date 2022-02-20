import 'package:flutter/material.dart';

abstract class IAppSettingsRepository {
  Future<void> saveAppLanguage(Locale locale);
  Future<void> savePrimaryColor(Color color);
  Future<void> saveSecondaryColor(Color color);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<Color?> getPrimaryColor();
  Future<Color?> getSecondaryColor();
  Future<ThemeMode?> getTheme();
}
