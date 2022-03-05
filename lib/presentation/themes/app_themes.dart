import 'package:flutter/material.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';

part './dark_theme.dart';
part './light_theme.dart';

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
      _light = _LightTheme(
        appState: appState,
        context: context,
      ).themeData;

      _dark = _DarkTheme(
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
