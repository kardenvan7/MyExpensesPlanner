import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/local_storage/hive_wrapper.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/main.dart';

class AppInitializer {
  Future<void> initialize() async {
    await runZonedGuarded(
      () async {
        try {
          WidgetsFlutterBinding.ensureInitialized();
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          await configureDependencies();
          await getIt<DatabaseWrapper>().initDatabase();
          await getIt<HiveWrapper>().initHive();
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
