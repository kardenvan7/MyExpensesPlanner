import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

class AppSettingsCaseImpl implements IAppSettingsCase {
  AppSettingsCaseImpl(this._appSettingsRepository);

  final IAppSettingsRepository _appSettingsRepository;

  @override
  Future<Result<FetchFailure, Locale>> getAppLanguage() async {
    return _appSettingsRepository.getAppLanguage();
  }

  @override
  Future<Result<FetchFailure, ThemeMode>> getTheme() async {
    return _appSettingsRepository.getTheme();
  }

  @override
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale) async {
    return _appSettingsRepository.saveAppLanguage(locale);
  }

  @override
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme) async {
    return _appSettingsRepository.saveTheme(theme);
  }
}
