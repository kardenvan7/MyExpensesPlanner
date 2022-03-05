import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';
import 'package:my_expenses_planner/presentation/themes/dark_theme.dart';
import 'package:my_expenses_planner/presentation/themes/light_theme.dart';

class AppThemes {
  AppThemes();

  late final ThemeData _light;
  late final ThemeData _dark;

  bool _initialized = false;

  bool get isInitialized => _initialized;

  ThemeData get light {
    if (!isInitialized) {
      throw const FormatException('AppThemes was not initialized');
    }

    return _light;
  }

  ThemeData get dark {
    if (!isInitialized) {
      throw const FormatException('AppThemes was not initialized');
    }

    return _dark;
  }

  void initialize({
    required AppState appState,
    required BuildContext context,
  }) {
    if (!_initialized) {
      _light = LightTheme(
        appState: appState,
        context: context,
      ).themeData;

      _dark = DarkTheme(
        appState: appState,
        context: context,
      ).themeData;

      _setInitialized();
    }
  }

  void _setInitialized() {
    _initialized = true;
  }
}
