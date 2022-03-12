import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/color_picker_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/main_screen.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/period_statistics_screen.dart';
import 'package:my_expenses_planner/presentation/ui/settings/settings_screen.dart';

import 'auto_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: MainScreen.routeName,
      page: MainScreen,
      initial: true,
    ),
    AutoRoute(
      path: EditTransactionScreen.routeName,
      page: EditTransactionScreen,
    ),
    AutoRoute(
      path: EditCategoryScreen.routeName,
      page: EditCategoryScreen,
    ),
    AutoRoute(
      path: SettingsScreen.routeName,
      page: SettingsScreen,
    ),
    AutoRoute<Color?>(
      path: ColorPickerScreen.routeName,
      page: ColorPickerScreen,
    ),
    AutoRoute(
      path: PeriodStatisticsScreen.routeName,
      page: PeriodStatisticsScreen,
    ),
  ],
)
class $AppRouter extends AppRouter {}
