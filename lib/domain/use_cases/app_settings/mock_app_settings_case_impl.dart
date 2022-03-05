import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

class MockAppSettingsCaseImpl implements IAppSettingsCase {
  @override
  Future<Locale?> getAppLanguage() {
    // TODO: implement getAppLanguage
    throw UnimplementedError();
  }

  @override
  Future<ThemeMode?> getTheme() {
    // TODO: implement getTheme
    throw UnimplementedError();
  }

  @override
  Future<void> saveAppLanguage(Locale locale) {
    // TODO: implement saveAppLanguage
    throw UnimplementedError();
  }

  @override
  Future<void> saveTheme(ThemeMode theme) {
    // TODO: implement saveTheme
    throw UnimplementedError();
  }
}
