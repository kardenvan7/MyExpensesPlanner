import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/local_storage/hive/hive_facade.dart';
import 'package:my_expenses_planner/data/local/providers/app_settings/i_app_settings_local_provider.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:collection/collection.dart';

class HiveAppSettingsLocalProvider implements IAppSettingsLocalProvider {
  HiveAppSettingsLocalProvider(this._hiveFacade);

  final HiveFacade _hiveFacade;

  static const String appLangKey = 'app_lang';
  static const String themeKey = 'theme_key';

  @override
  Future<Result<FetchFailure, Locale>> getAppLanguage() async {
    final Result<FetchFailure, String> _result =
        await _hiveFacade.get(appLangKey);

    return _result.fold(
      onFailure: (failure) => Result.failure(failure),
      onSuccess: (String value) {
        final Locale? _locale = LocaleFactory.fromLangString(value);

        if (_locale == null) {
          return Result.failure(FetchFailure.unknown());
        }

        return Result.success(_locale);
      },
    );
  }

  @override
  Future<Result<FetchFailure, ThemeMode>> getTheme() async {
    final Result<FetchFailure, String> _result =
        await _hiveFacade.get(themeKey);

    return _result.fold(
      onFailure: (failure) => Result.failure(failure),
      onSuccess: (String value) {
        final ThemeMode? _theme = ThemeMode.values.firstWhereOrNull(
          (element) => element.name == value,
        );

        if (_theme == null) {
          return Result.failure(FetchFailure.unknown());
        }

        return Result.success(_theme);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveAppLanguage(Locale locale) async {
    return _hiveFacade.put(appLangKey, locale.toLangString());
  }

  @override
  Future<Result<FetchFailure, void>> saveTheme(ThemeMode theme) async {
    return _hiveFacade.put(themeKey, theme.name);
  }
}
