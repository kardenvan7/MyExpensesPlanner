import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

abstract class IAppSettingsLocalProvider {
  Future<Result<FetchFailure, ThemeMode>> getTheme();
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme);

  Future<Result<FetchFailure, Locale>> getAppLanguage();
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale);
}