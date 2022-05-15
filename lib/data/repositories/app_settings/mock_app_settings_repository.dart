import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';

class MockAppSettingsRepository implements IAppSettingsRepository {
  Locale? _locale;
  ThemeMode? _themeMode;

  @override
  Future<Result<FetchFailure, Locale>> getAppLanguage() async {
    return Future.value(
      _locale == null
          ? Result.success(_locale!)
          : Result.failure(
              FetchFailure.notFound(),
            ),
    );
  }

  @override
  Future<Result<FetchFailure, ThemeMode>> getTheme() async {
    return Future.value(
      _themeMode == null
          ? Result.success(_themeMode!)
          : Result.failure(
              FetchFailure.notFound(),
            ),
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale) async {
    await Future.sync(() => _locale = locale);
    return Result.success(null);
  }

  @override
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme) async {
    await Future.sync(() => _themeMode = theme);
    return Result.success(null);
  }
}
