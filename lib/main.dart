import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/color_picker_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/main_screen.dart';
import 'package:my_expenses_planner/presentation/ui/settings/settings_screen.dart';

void main() async {
  await runZonedGuarded(
    () async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        await configureDependencies();
        // await EasyLocalization.ensureInitialized();
        await getIt<DatabaseWrapper>().initDatabase();
      } catch (e) {
        exit(1);
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };

      runApp(
        // const ConfiguredEasyLocalization(
        //   child:
        const MyExpensesPlanner(),
        // ),
      );
    },
    (Object error, StackTrace stack) {
      print(error);
      print(stack);
    },
  );
}

class MyExpensesPlanner extends StatelessWidget {
  const MyExpensesPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryListCubit>.value(
          value: getIt<CategoryListCubit>()..initialize(),
        ),
        BlocProvider<AppCubit>.value(
          value: getIt<AppCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return MaterialApp(
            themeMode: appState.themeMode,
            theme: _lightMode(
              appState: appState,
              context: context,
            ),
            darkTheme: _darkMode(
              appState: appState,
              context: context,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              SupportedLocales.english,
              SupportedLocales.russian,
            ],
            locale: appState.locale,
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }
}

ThemeData _darkMode({
  required AppState appState,
  required BuildContext context,
}) {
  const Color mainColor = Color(0xFF3d3d3d);
  const Color textColor = Colors.white70;

  return ThemeData(
    scaffoldBackgroundColor: mainColor,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: appState.secondaryColor,
      ),
      titleTextStyle: TextStyle(
        color: appState.secondaryColor,
        fontSize: 21,
        fontWeight: FontWeight.w500,
      ),
      actionsIconTheme: IconThemeData(
        color: appState.secondaryColor,
      ),
    ),
    textTheme: const TextTheme(
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
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
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
        ),
    colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: appState.primaryColor,
          secondary: appState.secondaryColor,
          error: Colors.red,
        ),
    listTileTheme: const ListTileThemeData(
      tileColor: Color(0xFF434343),
      textColor: textColor,
      iconColor: textColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: appState.secondaryColor,
        textStyle: const TextStyle(
          color: textColor,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: appState.secondaryColor,
        onPrimary: Colors.black,
        onSurface: Colors.black,
        textStyle: const TextStyle(
          color: textColor,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appState.secondaryColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: mainColor,
    ),
    cardTheme: const CardTheme(
      color: mainColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: mainColor,
    ),
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: Theme.of(context).buttonTheme.colorScheme!.copyWith(
                primary: appState.secondaryColor,
              ),
          buttonColor: appState.secondaryColor,
        ),
  );
}

ThemeData _lightMode({
  required AppState appState,
  required BuildContext context,
}) {
  const Color mainColor = Color(0xFFFFFFFF);
  const Color textColor = Colors.black;

  return ThemeData(
    scaffoldBackgroundColor: mainColor,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: appState.secondaryColor,
      ),
      titleTextStyle: TextStyle(
        color: appState.secondaryColor,
        fontSize: 21,
        fontWeight: FontWeight.w500,
      ),
      actionsIconTheme: IconThemeData(
        color: appState.secondaryColor,
      ),
    ),
    textTheme: const TextTheme(
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
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
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
        ),
    colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: appState.primaryColor,
          secondary: appState.secondaryColor,
          error: Colors.red,
        ),
    listTileTheme: const ListTileThemeData(
      tileColor: Color(0xFFFCFCFC),
      textColor: textColor,
      iconColor: textColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: appState.secondaryColor,
        textStyle: const TextStyle(
          color: textColor,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: appState.secondaryColor,
        onPrimary: Colors.black,
        onSurface: Colors.black,
        textStyle: const TextStyle(
          color: textColor,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appState.secondaryColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: mainColor,
    ),
    cardTheme: const CardTheme(
      color: mainColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: mainColor,
    ),
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: Theme.of(context).buttonTheme.colorScheme!.copyWith(
                primary: appState.secondaryColor,
              ),
          buttonColor: appState.secondaryColor,
        ),
  );
}

Route _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const MainScreen(),
      );

    case EditTransactionScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => EditTransactionScreen(
          transaction: settings.arguments as Transaction?,
        ),
      );

    case EditCategoryScreen.routeName:
      final TransactionCategory? category =
          settings.arguments as TransactionCategory?;

      return MaterialPageRoute(
        builder: (_) => EditCategoryScreen(
          category: category,
        ),
      );

    case SettingsScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      );

    case ColorPickerScreen.routeName:
      final Color? initialColor = settings.arguments as Color?;

      return MaterialPageRoute(
        builder: (_) => ColorPickerScreen(
          initialColor: initialColor ?? Colors.white,
        ),
      );

    default:
      throw Exception();
  }
}
