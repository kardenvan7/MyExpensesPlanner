part of 'app_cubit.dart';

class AppState {
  AppState({
    required this.locale,
    required this.themeMode,
  });

  final Locale locale;
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
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
