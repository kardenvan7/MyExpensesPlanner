part of 'app_cubit.dart';

class AppState {
  AppState({
    required this.locale,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Locale locale;
  final Color primaryColor;
  final Color secondaryColor;

  bool get isEnglishLocale => locale.isEnglish;
  bool get isRussianLocale => locale.isRussian;

  AppState copyWith({
    Locale? locale,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}
