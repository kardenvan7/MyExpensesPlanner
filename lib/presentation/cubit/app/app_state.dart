part of 'app_cubit.dart';

class AppState {
  AppState({
    required this.locale,
  });

  final Locale locale;

  bool get isEnglishLocale => locale.isEnglish;
  bool get isRussianLocale => locale.isRussian;
}
