part of 'app_cubit.dart';

class AppState {
  AppState({
    required this.locale,
    required this.primaryColor,
  });

  final Locale locale;
  final Color primaryColor;

  bool get isEnglishLocale => locale.isEnglish;
  bool get isRussianLocale => locale.isRussian;

  AppState copyWith({
    Locale? locale,
    Color? primaryColor,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
