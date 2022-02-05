import 'package:get_it/get_it.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/sqflite_transactions_repository.dart';

/// Syntax sugar. A shorter way for accessing [GetIt.instance].
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt

    /// sqflite db and repos
    ..registerSingleton<SqfliteDatabaseProvider>(
      SqfliteDatabaseProvider(),
    )
    ..registerSingleton<SqfliteCategoriesRepository>(
      SqfliteCategoriesRepository(getIt<SqfliteDatabaseProvider>()),
    )
    ..registerLazySingleton<SqfliteTransactionsRepository>(
      () => SqfliteTransactionsRepository(
        categoriesRepository: getIt<SqfliteCategoriesRepository>(),
        dbProvider: getIt<SqfliteDatabaseProvider>(),
      ),
    );

  await getIt.allReady();
}
