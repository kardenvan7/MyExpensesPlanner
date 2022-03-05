import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/models/app_settings.dart';

abstract class IAppSettingsRepository {
  Future<void> saveAppLanguage(Locale locale);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<ThemeMode?> getTheme();
  Future<AppSettings?> getAppSettings();
}
