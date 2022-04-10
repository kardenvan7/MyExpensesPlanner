import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_expenses_planner/data/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/main.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';

class AppInitializer {
  Future<void> initialize() async {
    await runZonedGuarded(
      () async {
        try {
          WidgetsFlutterBinding.ensureInitialized();
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          await configureDependencies();
          await getIt<ILocalDatabase>().initialize();
          await getIt<ILocalStorage>().initialize();
          await getIt<AppSettingsCubit>().initialize();
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
