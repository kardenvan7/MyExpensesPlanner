import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';

class AppSettings {
  AppSettings({
    this.locale,
    this.themeMode,
  });

  factory AppSettings.fromJson(Map json) {
    return AppSettings(
      locale: json['locale'] is String
          ? LocaleFactory.fromLangString(json['locale'] as String)
          : null,
      themeMode: ThemeMode.values.firstWhereOrNull(
        (element) => element.name == json['theme_mode'],
      ),
    );
  }

  final Locale? locale;
  final ThemeMode? themeMode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'locale': locale?.toLangString(),
      'theme_mode': themeMode?.name,
    };
  }
}
