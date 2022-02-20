import 'dart:ui';

import 'package:flutter/src/material/app.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

class MockAppSettingsCaseImpl implements IAppSettingsCase {
  @override
  Future<Locale?> getAppLanguage() {
    // TODO: implement getAppLanguage
    throw UnimplementedError();
  }

  @override
  Future<Color?> getPrimaryColor() {
    // TODO: implement getPrimaryColor
    throw UnimplementedError();
  }

  @override
  Future<Color?> getSecondaryColor() {
    // TODO: implement getSecondaryColor
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
  Future<void> savePrimaryColor(Color color) {
    // TODO: implement savePrimaryColor
    throw UnimplementedError();
  }

  @override
  Future<void> saveSecondaryColor(Color color) {
    // TODO: implement saveSecondaryColor
    throw UnimplementedError();
  }

  @override
  Future<void> saveTheme(ThemeMode theme) {
    // TODO: implement saveTheme
    throw UnimplementedError();
  }
}
