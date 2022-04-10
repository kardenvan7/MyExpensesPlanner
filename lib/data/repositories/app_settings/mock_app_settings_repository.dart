import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';

class MockAppSettingsRepository implements IAppSettingsRepository {
  Locale? _locale;
  ThemeMode? _themeMode;

  @override
  Future<Locale?> getAppLanguage() async {
    return Future.value(_locale);
  }

  @override
  Future<ThemeMode?> getTheme() async {
    return Future.value(_themeMode);
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    await Future.sync(() => _locale = locale);
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await Future.sync(() => _themeMode = theme);
  }
}
