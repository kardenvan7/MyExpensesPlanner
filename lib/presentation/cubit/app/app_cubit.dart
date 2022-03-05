import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/locale_extensions.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

part 'app_state.dart';

class AppSettingsCubit extends Cubit<AppState> {
  AppSettingsCubit({
    required IAppSettingsCase appSettingsCase,
  })  : _appSettingsCase = appSettingsCase,
        super(
          AppState(
            locale: SupportedLocales.english,
            themeMode: ThemeMode.system,
          ),
        );

  final IAppSettingsCase _appSettingsCase;

  bool initialized = false;

  Future<void> initialize() async {
    if (!initialized) {
      final _locale = await _appSettingsCase.getAppLanguage();
      final _theme = await _appSettingsCase.getTheme();

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
    try {
      _appSettingsCase.saveAppLanguage(locale);
    } catch (_) {}

    emit(state.copyWith(locale: locale));
  }

  void switchLanguage() {
    setLocale(
      state.locale.isEnglish
          ? SupportedLocales.russian
          : SupportedLocales.english,
    );
  }

  void switchTheme() {
    final ThemeMode _newMode =
        state.isLightTheme ? ThemeMode.dark : ThemeMode.light;

    try {
      _appSettingsCase.saveTheme(_newMode);
    } catch (_) {}

    emit(
      state.copyWith(
        themeMode: _newMode,
      ),
    );
  }
}
