import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';

class SecureStorage implements ILocalStorage {
  SecureStorage(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  static const String appLangKey = 'app_lang';
  static const String primaryColorKey = 'primary_color';
  static const String secondaryColorKey = 'secondary_color';
  static const String themeKey = 'theme_key';

  /// App Settings

  @override
  Future<Locale?> getAppLanguage() async {
    final String? _langString = await _flutterSecureStorage.read(
      key: appLangKey,
    );

    if (_langString == null) {
      return null;
    }

    return _LocaleFactory.fromLangString(_langString);
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

extension _LocaleFactory on Locale {
  String toLangString() {
    return '${languageCode}_$countryCode';
  }

  static Locale? fromLangString(String _langString) {
    final List<String> _localeComponents = _langString.split('_');

    if (_localeComponents.length < 2) {
      return null;
    }

    return Locale(
      _localeComponents[0],
      _localeComponents[1],
    );
  }

  /// Other
}
