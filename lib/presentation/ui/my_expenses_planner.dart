import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/themes/app_themes.dart';

class MyExpensesPlanner extends StatelessWidget {
  const MyExpensesPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryListCubit>.value(
          value: DI.instance<CategoryListCubit>()..initialize(),
        ),
        BlocProvider<AppSettingsCubit>.value(
          value: DI.instance<AppSettingsCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, appState) {
          final AppThemes _themes = AppThemes()
            ..initialize(
              context: context,
            );

          return MaterialApp.router(
            title: AppLocalizationsFacade.getAppTitle(appState.locale),
            scaffoldMessengerKey: NavigatorService.key,
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
            routerDelegate: DI.instance<AppRouter>().delegate(),
            routeInformationParser: DI.instance<AppRouter>().defaultRouteParser(),
            // home: const MainScreen(),
            // onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }
}

class NavigatorService {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();
}
