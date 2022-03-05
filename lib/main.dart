import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_expenses_planner/app_initializer.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/themes/app_themes.dart';

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
        BlocProvider<AppSettingsCubit>.value(
          value: getIt<AppSettingsCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
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
