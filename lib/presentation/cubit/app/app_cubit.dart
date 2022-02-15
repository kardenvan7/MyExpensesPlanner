import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/locale_extension.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required Locale defaultLocale})
      : super(AppState(
          locale: defaultLocale,
        ));

  void setLocale(Locale locale) {
    emit(AppState(locale: locale));
  }

  void switchLanguage() {
    setLocale(
      state.locale.isEnglish
          ? SupportedLocales.russian
          : SupportedLocales.english,
    );
  }
}