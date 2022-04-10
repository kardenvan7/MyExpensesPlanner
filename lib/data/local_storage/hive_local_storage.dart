import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/data/local_storage/hive_facade.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';

class HiveLocalStorage implements ILocalStorage {
  HiveLocalStorage(this._hiveFacade);

  Box get box => _hiveFacade.box;

  final HiveFacade _hiveFacade;

  static const String appLangKey = 'app_lang';
  static const String themeKey = 'theme_key';
  static const String appSettingsKey = 'app_settings';

  @override
  Future<void> initialize() async {
    await _hiveFacade.initHive();
  }

  @override
  Future<Locale?> getAppLanguage() async {
    final String? _appLang = box.get(appLangKey);

    return _appLang != null ? LocaleFactory.fromLangString(_appLang) : null;
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
  Future<void> saveAppLanguage(Locale locale) async {
    await box.put(appLangKey, locale.toLangString());
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    await box.put(themeKey, theme.name);
  }
}
