import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/data/models/app_settings.dart';

class FlutterSecureLocalStorage implements ILocalStorage {
  FlutterSecureLocalStorage(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  static const String appLangKey = 'app_lang';
  static const String primaryColorKey = 'primary_color';
  static const String secondaryColorKey = 'secondary_color';
  static const String themeKey = 'theme_key';
  static const String appSettingsKey = 'app_settings';

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
  Future<Color?> getPrimaryColor() async {
    final String? _colorHex = await _flutterSecureStorage.read(
      key: primaryColorKey,
    );

    if (_colorHex == null) {
      return null;
    }

    return HexColor.fromHex(_colorHex);
  }

  @override
  Future<Color?> getSecondaryColor() async {
    final String? _colorHex = await _flutterSecureStorage.read(
      key: secondaryColorKey,
    );

    if (_colorHex == null) {
      return null;
    }

    return HexColor.fromHex(_colorHex);
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
  Future<AppSettings?> getAppSettings() async {
    final Map<String, String> _values = await _flutterSecureStorage.readAll();

    return AppSettings(
      locale: _values[appLangKey] != null
          ? LocaleFactory.fromLangString(_values[appLangKey]!)
          : null,
      primaryColor: _values[primaryColorKey] != null
          ? HexColor.fromHex(_values[primaryColorKey]!)
          : null,
      secondaryColor: _values[secondaryColorKey] != null
          ? HexColor.fromHex(_values[secondaryColorKey]!)
          : null,
      themeMode: ThemeMode.values.firstWhereOrNull(
        (element) => element.name == _values[themeKey],
      ),
    );
  }

  @override
  Future<void> savePrimaryColor(Color color) async {
    await _flutterSecureStorage.write(
      key: primaryColorKey,
      value: color.toHexString(),
    );
  }

  @override
  Future<void> saveSecondaryColor(Color color) async {
    await _flutterSecureStorage.write(
      key: secondaryColorKey,
      value: color.toHexString(),
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
