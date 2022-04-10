import 'package:flutter/material.dart';

abstract class ILocalStorage {
  Future<void> initialize();

  /// App Settings
  Future<void> saveAppLanguage(Locale locale);
  Future<void> saveTheme(ThemeMode theme);

  Future<Locale?> getAppLanguage();
  Future<ThemeMode?> getTheme();
}
