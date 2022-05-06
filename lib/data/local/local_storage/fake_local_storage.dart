import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/local/local_storage/i_local_storage.dart';

class FakeLocalStorage implements ILocalStorage {
  Locale? _locale;
  ThemeMode? _themeMode;

  @override
  Future<Locale?> getAppLanguage() async {
    return Future.value(_locale);
  }

  @override
  Future<ThemeMode?> getTheme() {
    return Future.value(_themeMode);
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    await Future.sync(() => _locale = locale);
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await Future.sync(() => _themeMode = theme);
  }

  @override
  Future<void> initialize() async {
    await Future.sync(() => null);
  }
}
