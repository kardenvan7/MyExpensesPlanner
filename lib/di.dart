import 'package:get_it/get_it.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/i_transactions_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/sqflite_transactions_repository.dart';

/// Syntax sugar. A shorter way for accessing [GetIt.instance].
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt

    /// sqflite db and repos
    ..registerSingleton<DatabaseWrapper>(
      DatabaseWrapper(
        SqfliteDatabaseProvider(),
      ),
    )
    ..registerSingleton<ICategoriesRepository>(
      SqfliteCategoriesRepository(getIt<DatabaseWrapper>()),
    )
    ..registerLazySingleton<ITransactionsRepository>(
      () => SqfliteTransactionsRepository(
        categoriesRepository: SqfliteCategoriesRepository(
          getIt<DatabaseWrapper>(),
        ),
        dbWrapper: getIt<DatabaseWrapper>(),
      ),
    );

  await getIt.allReady();
}
