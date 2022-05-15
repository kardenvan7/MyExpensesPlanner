import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/my_expenses_planner.dart';

class AppInitializer {
  Future<void> initialize() async {
    await runZonedGuarded(
      () async {
        try {
          WidgetsFlutterBinding.ensureInitialized();
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          await DI.configureDependencies();
          await DI.instance<ILocalDatabase>().initialize();
          await DI.instance<AppSettingsCubit>().initialize();
        } catch (e) {
          exit(1);
        }

        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
        };

        runApp(const MyExpensesPlanner());
      },
      (Object error, StackTrace stack) {
        print(error);
        print(stack);
      },
    );
  }
}
