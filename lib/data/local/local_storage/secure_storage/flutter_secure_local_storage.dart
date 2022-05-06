import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/data/local/local_storage/i_local_storage.dart';

class FlutterSecureLocalStorage implements ILocalStorage {
  FlutterSecureLocalStorage(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  static const String appLangKey = 'app_lang';
  static const String themeKey = 'theme_key';

  @override
  Future<void> initialize() async {
    await Future.sync(() => null);
  }

  /// App Settings

  @override
  Future<Locale?> getAppLanguage() async {
    final String? _langString = await _flutterSecureStorage.read(
      key: appLangKey,
    );

    if (_langString == null) {
      return null;
    }

    return LocaleFactory.fromLangString(_langString);
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    await _flutterSecureStorage.write(
      key: appLangKey,
      value: locale.toLangString(),
    );
  }

  @override
  Future<ThemeMode?> getTheme() async {
    final String? _themeCode = await _flutterSecureStorage.read(
      key: themeKey,
    );

    if (_themeCode == null) {
      return null;
    }

    return ThemeMode.values.firstWhereOrNull(
      (element) => element.name == _themeCode,
    );
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await _flutterSecureStorage.write(
      key: themeKey,
      value: theme.name,
    );
  }
}