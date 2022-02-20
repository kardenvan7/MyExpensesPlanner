part of 'app_cubit.dart';

class AppState {
  AppState({
    required this.locale,
    required this.primaryColor,
    required this.secondaryColor,
    required this.themeMode,
  });

  final Locale locale;
  final Color primaryColor;
  final Color secondaryColor;
  final ThemeMode themeMode;

  bool get isEnglishLocale => locale.isEnglish;
  bool get isRussianLocale => locale.isRussian;

  bool get isLightTheme => themeMode == ThemeMode.light;
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  AppState copyWith({
    Locale? locale,
    Color? primaryColor,
    Color? secondaryColor,
    ThemeMode? themeMode,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
