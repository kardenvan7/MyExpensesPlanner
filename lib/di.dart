import 'package:get_it/get_it.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/i_transactions_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/sqflite_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/categories_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';

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
        dbWrapper: getIt<DatabaseWrapper>(),
      ),
    )

    /// Use cases
    ..registerLazySingleton<ITransactionsCase>(
      () => TransactionsCaseImpl(
        transactionsRepository: getIt<ITransactionsRepository>(),
      ),
    )
    ..registerLazySingleton<ICategoriesCase>(
      () => CategoriesCaseImpl(
        categoriesRepository: getIt<ICategoriesRepository>(),
      ),
    )

    /// Global singletons
    ..registerLazySingleton<CategoryListCubit>(
      () => CategoryListCubit(
        categoriesCaseImpl: getIt<ICategoriesCase>(),
      ),
    );

  await getIt.allReady();
}
