import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_expenses_planner/app_initializer.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/themes/app_themes.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/color_picker_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/main_screen.dart';
import 'package:my_expenses_planner/presentation/ui/settings/settings_screen.dart';

void main() async {
  final _appInitializer = AppInitializer();

  await _appInitializer.initialize();
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
          final AppThemes _themes = AppThemes()
            ..initialize(
              appState: appState,
              context: context,
            );

          return MaterialApp.router(
            themeMode: appState.themeMode,
            theme: _themes.light,
            darkTheme: _themes.dark,
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
            routerDelegate: getIt<AppRouter>().delegate(),
            routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
            // home: const MainScreen(),
            // onGenerateRoute: _onGenerateRoute,
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
