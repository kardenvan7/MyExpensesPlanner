import 'package:flutter/material.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';

class DarkTheme {
  static const Color mainColor = Color(0xFF3d3d3d);
  static const Color textColor = Colors.white70;

  DarkTheme({
    required AppState appState,
    required BuildContext context,
  })  : _appState = appState,
        _context = context;

  final AppState _appState;
  final BuildContext _context;

  ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: mainColor,
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
    );
  }

  AppBarTheme get _appBarTheme => AppBarTheme(
        iconTheme: IconThemeData(
          color: _appState.secondaryColor,
        ),
        titleTextStyle: TextStyle(
          color: _appState.secondaryColor,
          fontSize: 21,
          fontWeight: FontWeight.w500,
        ),
        actionsIconTheme: IconThemeData(
          color: _appState.secondaryColor,
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
        color: Colors.white70,
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
          );

  ColorScheme get _colorScheme => Theme.of(_context).colorScheme.copyWith(
        primary: _appState.primaryColor,
        secondary: _appState.secondaryColor,
        error: Colors.red,
      );

  ListTileThemeData get _listTileThemeData => const ListTileThemeData(
        tileColor: Color(0xFF434343),
        textColor: textColor,
        iconColor: textColor,
      );

  TextButtonThemeData get _textButtonThemeData => TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: _appState.secondaryColor,
          textStyle: const TextStyle(
            color: textColor,
          ),
        ),
      );

  ElevatedButtonThemeData get _elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: _appState.secondaryColor,
          onPrimary: Colors.black,
          onSurface: Colors.black,
          textStyle: const TextStyle(
            color: textColor,
          ),
        ),
      );

  FloatingActionButtonThemeData get _floatingActionButtonThemeData =>
      FloatingActionButtonThemeData(
        backgroundColor: _appState.secondaryColor,
      );

  DialogTheme get _dialogTheme => const DialogTheme(
        backgroundColor: mainColor,
      );

  CardTheme get _cardTheme => const CardTheme(
        color: mainColor,
      );

  DrawerThemeData get _drawerThemeData => const DrawerThemeData(
        backgroundColor: mainColor,
      );

  ButtonThemeData get _buttonThemeData =>
      Theme.of(_context).buttonTheme.copyWith(
            colorScheme: Theme.of(_context).buttonTheme.colorScheme!.copyWith(
                  primary: _appState.secondaryColor,
                ),
            buttonColor: _appState.secondaryColor,
          );
}
