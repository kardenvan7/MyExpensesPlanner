import 'package:get_it/get_it.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/local_storage/hive_local_storage.dart';
import 'package:my_expenses_planner/data/local_storage/hive_wrapper.dart';
import 'package:my_expenses_planner/data/local_storage/i_local_storage.dart';
import 'package:my_expenses_planner/data/repositories/app_settings/app_settings_repository.dart';
import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/sqflite_transactions_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/app_settings_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/categories_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

/// Syntax sugar. A shorter way for accessing [GetIt.instance].
final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt

    /// dbs, storages and repos
    ..registerSingleton<DatabaseWrapper>(
      DatabaseWrapper(
        SqfliteDatabaseProvider(),
      ),
    )
    ..registerSingleton<HiveWrapper>(
      HiveWrapper(),
    )
    ..registerSingleton<ILocalStorage>(
      HiveLocalStorage(getIt<HiveWrapper>()),
    )
    ..registerSingleton<ICategoriesRepository>(
      SqfliteCategoriesRepository(getIt<DatabaseWrapper>()),
    )
    ..registerLazySingleton<ITransactionsRepository>(
      () => SqfliteTransactionsRepository(
        dbWrapper: getIt<DatabaseWrapper>(),
      ),
    )
    ..registerLazySingleton<IAppSettingsRepository>(
      () => AppSettingsRepository(
        getIt<ILocalStorage>(),
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
    ..registerLazySingleton<IAppSettingsCase>(
      () => AppSettingsCaseImpl(
        getIt<IAppSettingsRepository>(),
      ),
    )

    /// Global singletons
    ..registerSingleton<AppRouter>(
      AppRouter(),
    )
    ..registerLazySingleton<CategoryListCubit>(
      () => CategoryListCubit(
        categoriesCaseImpl: getIt<ICategoriesCase>(),
      ),
    )
    ..registerLazySingleton<AppSettingsCubit>(
      () => AppSettingsCubit(
        appSettingsCase: getIt<IAppSettingsCase>(),
      ),
    );

  await getIt.allReady();
}
