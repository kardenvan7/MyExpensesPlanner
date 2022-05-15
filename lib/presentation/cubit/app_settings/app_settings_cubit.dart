import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

part 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    required IAppSettingsCase appSettingsCase,
  })  : _appSettingsCase = appSettingsCase,
        super(
          AppSettingsState(
            locale: SupportedLocales.english,
            themeMode: ThemeMode.dark,
          ),
        );

  final IAppSettingsCase _appSettingsCase;

  bool initialized = false;

  Future<void> initialize() async {
    if (!initialized) {
      Locale? _locale;
      ThemeMode? _theme;

      final _localeFetchResult = await _appSettingsCase.getAppLanguage();

      _localeFetchResult.fold(
        onFailure: (_) {},
        onSuccess: (locale) {
          _locale = locale;
        },
      );

      final _themeFetchResult = await _appSettingsCase.getTheme();

      _themeFetchResult.fold(
        onFailure: (_) {},
        onSuccess: (theme) {
          _theme = theme;
        },
      );

      emit(
        state.copyWith(
          locale: _locale,
          themeMode: _theme,
        ),
      );

      initialized = true;
    }
  }

  void setLocale(Locale locale) {
    _appSettingsCase.saveAppLanguage(locale);

    emit(state.copyWith(locale: locale));
  }

  void switchTheme() {
    final ThemeMode _newMode =
        state.isLightTheme ? ThemeMode.dark : ThemeMode.light;

    _appSettingsCase.saveTheme(_newMode);

    emit(
      state.copyWith(
        themeMode: _newMode,
      ),
    );
  }
}
