import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/data/models/app_settings.dart';
import 'package:my_expenses_planner/domain/models/app_settings.dart' as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';

class AppSettingsRepository implements IAppSettingsRepository {
  AppSettingsRepository(this._localStorage);

  final ILocalStorage _localStorage;

  @override
  Future<Locale?> getAppLanguage() async {
    return _localStorage.getAppLanguage();
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
  Future<void> saveTheme(ThemeMode theme) async {
    await _localStorage.saveTheme(theme);
  }

  @override
  Future<domain.AppSettings?> getAppSettings() async {
    final AppSettings? _dataAppSettings = await _localStorage.getAppSettings();

    return domain.AppSettings(
      locale: _dataAppSettings?.locale,
      themeMode: _dataAppSettings?.themeMode,
    );
  }
}
