import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';

class AppSettings {
  AppSettings({
    this.locale,
    this.primaryColor,
    this.secondaryColor,
    this.themeMode,
  });

  factory AppSettings.fromJson(Map json) {
    return AppSettings(
      locale: json['locale'] is String
          ? LocaleFactory.fromLangString(json['locale'] as String)
          : null,
      primaryColor: json['primary_color'] is String
          ? HexColor.fromHex(json['primary_color'] as String)
          : null,
      secondaryColor: json['secondary_color'] is String
          ? HexColor.fromHex(json['secondary_color'] as String)
          : null,
      themeMode: ThemeMode.values.firstWhereOrNull(
        (element) => element.name == json['theme_mode'],
      ),
    );
  }

  final Locale? locale;
  final Color? primaryColor;
  final Color? secondaryColor;
  final ThemeMode? themeMode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'locale': locale?.toLangString(),
      'primary_color': primaryColor?.toHexString(),
      'secondary_color': secondaryColor?.toHexString(),
      'theme_mode': themeMode?.name,
    };
  }
}
