import 'package:flutter/material.dart';

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
    required BuildContext context,
  }) {
    if (!_initialized) {
      _light = _LightTheme(
        context: context,
      ).themeData;

      _dark = _DarkTheme(
        context: context,
      ).themeData;

      _setInitialized();
    }
  }

  void _setInitialized() {
    _initialized = true;
  }
}
