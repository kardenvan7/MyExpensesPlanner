import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/data/repositories/app_settings/i_app_settings_repository.dart';

class AppSettingsRepository implements IAppSettingsRepository {
  AppSettingsRepository(this._localStorage);

  final ILocalStorage _localStorage;

  @override
  Future<Locale?> getAppLanguage() async {
    return _localStorage.getAppLanguage();
  }

  @override
  Future<Color?> getPrimaryColor() async {
    return _localStorage.getPrimaryColor();
  }

  @override
  Future<Color?> getSecondaryColor() async {
    return _localStorage.getSecondaryColor();
  }

  @override
  Future<ThemeMode?> getTheme() async {
    return _localStorage.getTheme();
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    await _localStorage.saveAppLanguage(locale);
  }

  @override
  Future<void> savePrimaryColor(Color color) async {
    await _localStorage.savePrimaryColor(color);
  }

  @override
  Future<void> saveSecondaryColor(Color color) async {
    await _localStorage.saveSecondaryColor(color);
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await _localStorage.saveTheme(theme);
  }
}
