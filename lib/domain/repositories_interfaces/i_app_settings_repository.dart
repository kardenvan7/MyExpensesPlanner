import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/models/app_settings.dart';

abstract class IAppSettingsRepository {
  Future<void> saveAppLanguage(Locale locale);
  Future<void> savePrimaryColor(Color color);
  Future<void> saveSecondaryColor(Color color);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<Color?> getPrimaryColor();
  Future<Color?> getSecondaryColor();
  Future<ThemeMode?> getTheme();
  Future<AppSettings?> getAppSettings();
}
