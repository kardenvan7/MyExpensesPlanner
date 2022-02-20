import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

class AppSettingsCaseImpl implements IAppSettingsCase {
  AppSettingsCaseImpl(this._appSettingsRepository);

  final IAppSettingsRepository _appSettingsRepository;

  @override
  Future<Locale?> getAppLanguage() async {
    return _appSettingsRepository.getAppLanguage();
  }

  @override
  Future<Color?> getPrimaryColor() async {
    return _appSettingsRepository.getPrimaryColor();
  }

  @override
  Future<Color?> getSecondaryColor() async {
    return _appSettingsRepository.getSecondaryColor();
  }

  @override
  Future<ThemeMode?> getTheme() async {
    return _appSettingsRepository.getTheme();
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    await _appSettingsRepository.saveAppLanguage(locale);
  }

  @override
  Future<void> savePrimaryColor(Color color) async {
    await _appSettingsRepository.savePrimaryColor(color);
  }

  @override
  Future<void> saveSecondaryColor(Color color) async {
    await _appSettingsRepository.saveSecondaryColor(color);
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await _appSettingsRepository.saveTheme(theme);
  }
}
