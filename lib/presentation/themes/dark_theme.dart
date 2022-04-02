part of './app_themes.dart';

class _DarkTheme {
  static const Color primaryColor = Color(0xFF3d3d3d);
  static const Color secondaryColor = Colors.white70;
  static const Color textColor = secondaryColor;

  _DarkTheme({
    required BuildContext context,
  }) : _context = context;

  final BuildContext _context;

  ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: primaryColor,
      appBarTheme: _appBarTheme,
      textTheme: _textTheme,
      iconTheme: _iconThemeData,
      inputDecorationTheme: _inputDecorationTheme,
      colorScheme: _colorScheme,
      listTileTheme: _listTileThemeData,
      textButtonTheme: _textButtonThemeData,
      elevatedButtonTheme: _elevatedButtonThemeData,
      floatingActionButtonTheme: _floatingActionButtonThemeData,
      dialogTheme: _dialogTheme,
      cardTheme: _cardTheme,
      drawerTheme: _drawerThemeData,
      buttonTheme: _buttonThemeData,
      textSelectionTheme: _textSelectionThemeData,
    );
  }

  AppBarTheme get _appBarTheme => const AppBarTheme(
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
        actionsIconTheme: IconThemeData(
          color: secondaryColor,
        ),
      );

  TextTheme get _textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
      );

  IconThemeData get _iconThemeData => const IconThemeData(
        color: secondaryColor,
      );

  InputDecorationTheme get _inputDecorationTheme =>
      Theme.of(_context).inputDecorationTheme.copyWith(
            helperStyle: const TextStyle(
              fontSize: 14,
              color: textColor,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            labelStyle: TextStyle(
              color: textColor.withOpacity(0.4),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
                width: 2.5,
              ),
            ),
          );

  ColorScheme get _colorScheme => Theme.of(_context).colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        error: Colors.red,
      );

  ListTileThemeData get _listTileThemeData => const ListTileThemeData(
        tileColor: Color(0xFF434343),
        textColor: textColor,
        iconColor: textColor,
      );

  TextButtonThemeData get _textButtonThemeData => TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: secondaryColor,
          textStyle: const TextStyle(
            color: textColor,
          ),
        ),
      );

  ElevatedButtonThemeData get _elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: secondaryColor,
          onPrimary: Colors.black,
          onSurface: Colors.black,
          textStyle: const TextStyle(
            color: textColor,
          ),
        ),
      );

  FloatingActionButtonThemeData get _floatingActionButtonThemeData =>
      const FloatingActionButtonThemeData(
        shape: CircleBorder(),
        foregroundColor: primaryColor,
        backgroundColor: secondaryColor,
        elevation: 0,
      );

  DialogTheme get _dialogTheme => const DialogTheme(
        backgroundColor: Color(0xFF333333),
      );

  CardTheme get _cardTheme => const CardTheme(
        color: primaryColor,
      );

  DrawerThemeData get _drawerThemeData => const DrawerThemeData(
        backgroundColor: primaryColor,
      );

  ButtonThemeData get _buttonThemeData =>
      Theme.of(_context).buttonTheme.copyWith(
            colorScheme: Theme.of(_context).buttonTheme.colorScheme!.copyWith(
                  primary: secondaryColor,
                ),
            buttonColor: secondaryColor,
          );

  TextSelectionThemeData get _textSelectionThemeData => TextSelectionThemeData(
        cursorColor: secondaryColor,
        selectionColor: secondaryColor.withOpacity(0.3),
        selectionHandleColor: secondaryColor.withOpacity(1),
      );
}
