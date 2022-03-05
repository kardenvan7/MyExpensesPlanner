import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/data/local_storage/hive_wrapper.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/data/models/app_settings.dart';

class HiveLocalStorage implements ILocalStorage {
  HiveLocalStorage(this._hiveWrapper);

  Box get box => _hiveWrapper.box;

  final HiveWrapper _hiveWrapper;

  static const String appLangKey = 'app_lang';
  static const String primaryColorKey = 'primary_color';
  static const String secondaryColorKey = 'secondary_color';
  static const String themeKey = 'theme_key';
  static const String appSettingsKey = 'app_settings';

  @override
  Future<Locale?> getAppLanguage() async {
    final String? _appLang = box.get(appLangKey);

    return _appLang != null ? LocaleFactory.fromLangString(_appLang) : null;
  }

  @override
  Future<Color?> getPrimaryColor() async {
    final String? _hex = box.get(primaryColorKey);

    return Future.value(
      _hex != null ? HexColor.fromHex(_hex) : null,
    );
  }

  @override
  Future<Color?> getSecondaryColor() async {
    final String? _hex = box.get(secondaryColorKey);

    return Future.value(
      _hex != null ? HexColor.fromHex(_hex) : null,
    );
  }

  @override
  Future<ThemeMode?> getTheme() async {
    final String? _themeName = box.get(themeKey);

    return Future.value(
      ThemeMode.values.firstWhereOrNull(
        (element) => element.name == _themeName,
      ),
    );
  }

  @override
  Future<AppSettings?> getAppSettings() async {
    return Future.value(
      AppSettings(
        locale: await getAppLanguage(),
        primaryColor: await getPrimaryColor(),
        secondaryColor: await getSecondaryColor(),
        themeMode: await getTheme(),
      ),
    );
  }

  @override
  Future<void> saveAppLanguage(Locale locale) async {
    box.put(appLangKey, locale.toLangString());
  }

  @override
  Future<void> savePrimaryColor(Color color) async {
    box.put(primaryColorKey, color.toHexString());
  }

  @override
  Future<void> saveSecondaryColor(Color color) async {
    box.put(secondaryColorKey, color.toHexString());
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    box.put(themeKey, theme.name);
  }
}
