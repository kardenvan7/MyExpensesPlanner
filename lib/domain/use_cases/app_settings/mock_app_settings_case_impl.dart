import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

class MockAppSettingsCaseImpl implements IAppSettingsCase {
  @override
  Future<Result<FetchFailure, Locale>> getAppLanguage() {
    // TODO: implement getAppLanguage
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, ThemeMode>> getTheme() {
    // TODO: implement getTheme
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale) {
    // TODO: implement saveAppLanguage
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme) {
    // TODO: implement saveTheme
    throw UnimplementedError();
  }
}
