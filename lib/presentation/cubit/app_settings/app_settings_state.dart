part of 'app_settings_cubit.dart';

class AppSettingsState {
  AppSettingsState({
    required this.locale,
    required this.themeMode,
  });

  final Locale locale;
  final ThemeMode themeMode;

  bool get isEnglishLocale => locale.isEnglish;
  bool get isRussianLocale => locale.isRussian;

  bool get isLightTheme => themeMode == ThemeMode.light;
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  AppSettingsState copyWith({
    Locale? locale,
    Color? primaryColor,
    Color? secondaryColor,
    ThemeMode? themeMode,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
