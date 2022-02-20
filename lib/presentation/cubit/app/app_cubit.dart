import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/locale_extension.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required IAppSettingsCase appSettingsCase,
    required Locale locale,
    required Color primaryColor,
    required Color secondaryColor,
    required ThemeMode themeMode,
  })  : _appSettingsCase = appSettingsCase,
        super(
          AppState(
            locale: locale,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            themeMode: themeMode,
          ),
        );

  final IAppSettingsCase _appSettingsCase;

  bool initialized = false;

  Future<void> initialize() async {
    if (!initialized) {
      final _locale = await _appSettingsCase.getAppLanguage();
      final _primColor = await _appSettingsCase.getPrimaryColor();
      final _secondColor = await _appSettingsCase.getSecondaryColor();
      final _theme = await _appSettingsCase.getTheme();

      emit(
        state.copyWith(
          locale: _locale,
          primaryColor: _primColor,
          secondaryColor: _secondColor,
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

  void setPrimaryColor(Color color) {
    try {
      _appSettingsCase.savePrimaryColor(color);
    } catch (_) {}

    emit(state.copyWith(primaryColor: color));
  }

  void setSecondaryColor(Color color) {
    try {
      _appSettingsCase.saveSecondaryColor(color);
    } catch (_) {}

    emit(state.copyWith(secondaryColor: color));
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
