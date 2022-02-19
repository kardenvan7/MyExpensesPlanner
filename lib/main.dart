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
          value: getIt<AppCubit>(),
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return MaterialApp(
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
            // localizationsDelegates: context.localizationDelegates,
            // supportedLocales: context.supportedLocales,
            // locale: state.locale,
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
            onGenerateRoute: _onGenerateRoute,
            theme: ThemeData(
              textTheme: const TextTheme(
                headline3: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              inputDecorationTheme:
                  Theme.of(context).inputDecorationTheme.copyWith(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: appState.primaryColor,
                    secondary: Colors.orangeAccent,
                    error: Colors.red,
                  ),
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                    colorScheme:
                        Theme.of(context).buttonTheme.colorScheme!.copyWith(
                              primary: Colors.orangeAccent,
                            ),
                    buttonColor: Colors.orangeAccent,
                  ),
            ),
          );
        },
      ),
    );
  }
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
