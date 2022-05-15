import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

abstract class IAppSettingsCase {
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale);
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme);

  Future<Result<FetchFailure, Locale>> getAppLanguage();
  Future<Result<FetchFailure, ThemeMode>> getTheme();
}
