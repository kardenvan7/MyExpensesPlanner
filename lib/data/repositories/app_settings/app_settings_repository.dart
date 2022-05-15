import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/providers/app_settings/i_app_settings_local_provider.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';

class AppSettingsRepository implements IAppSettingsRepository {
  AppSettingsRepository(this._localProvider);

  final IAppSettingsLocalProvider _localProvider;

  @override
  Future<Result<FetchFailure, Locale>> getAppLanguage() async {
    return _localProvider.getAppLanguage();
  }

  @override
  Future<Result<FetchFailure, ThemeMode>> getTheme() async {
    return _localProvider.getTheme();
  }

  @override
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale) async {
    return _localProvider.saveAppLanguage(locale);
  }

  @override
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme) async {
    return _localProvider.saveTheme(theme);
  }
}
