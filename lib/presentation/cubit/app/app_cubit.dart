import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/locale_extension.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required Locale locale,
    required Color primaryColor,
    required Color secondaryColor,
    required ThemeMode themeMode,
  }) : super(
          AppState(
            locale: locale,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            themeMode: themeMode,
          ),
        );

  bool initialized = false;

  Future<void> initialize() async {
    if (!initialized) {
      initialized = true;
    }
  }

  void setLocale(Locale locale) {
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
    emit(state.copyWith(primaryColor: color));
  }

  void setSecondaryColor(Color color) {
    emit(state.copyWith(secondaryColor: color));
  }

  void switchTheme() {
    emit(
      state.copyWith(
        themeMode: state.isLightTheme ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
