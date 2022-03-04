import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/models/app_settings.dart';

abstract class ILocalStorage {
  /// App Settings
  Future<void> saveAppLanguage(Locale locale);
  Future<void> savePrimaryColor(Color color);
  Future<void> saveSecondaryColor(Color color);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<Color?> getPrimaryColor();
  Future<Color?> getSecondaryColor();
  Future<ThemeMode?> getTheme();
  Future<AppSettings?> getAppSettings();

  /// Other
}
