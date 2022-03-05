import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/models/app_settings.dart';

abstract class ILocalStorage {
  /// App Settings
  Future<void> saveAppLanguage(Locale locale);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<ThemeMode?> getTheme();
  Future<AppSettings?> getAppSettings();

  /// Other
}
