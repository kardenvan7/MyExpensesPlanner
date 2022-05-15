import 'package:get_it/get_it.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/local/local_db/sqflite/sqflite_database_facade.dart';
import 'package:my_expenses_planner/data/local/local_db/sqflite/sqflite_db_provider.dart';
import 'package:my_expenses_planner/data/local/local_db/sqflite/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/local/local_storage/hive/hive_facade.dart';
import 'package:my_expenses_planner/data/local/providers/app_settings/i_app_settings_local_provider.dart';
import 'package:my_expenses_planner/data/local/providers/app_settings/local_storage_app_settings_local_provider.dart';
import 'package:my_expenses_planner/data/local/providers/categories/i_categories_local_provider.dart';
import 'package:my_expenses_planner/data/local/providers/categories/local_db_categories_local_provider.dart';
import 'package:my_expenses_planner/data/local/providers/transactions/i_transactions_local_provider.dart';
import 'package:my_expenses_planner/data/local/providers/transactions/local_db_transactions_local_provider.dart';
import 'package:my_expenses_planner/data/repositories/app_settings/app_settings_repository.dart';
import 'package:my_expenses_planner/data/repositories/categories/categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/transactions_repository.dart';
import 'package:my_expenses_planner/domain/core/export/data_export_handler.dart';
import 'package:my_expenses_planner/domain/core/import/data_import_handler.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_app_settings_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/app_settings_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/app_settings/i_app_settings_case.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/categories_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/export/export_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/import/import_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

class DI {
  static GetIt instance = GetIt.instance;

  static Future<void> configureDependencies() async {
    final GetIt getIt = GetIt.instance;
    getIt

      /// Global singletons
      ..registerSingletonAsync<HiveFacade>(
        () async {
          final HiveFacade _facade = HiveFacade();

          await _facade.initHive();

          return _facade;
        },
      )
      ..registerSingleton<AppRouter>(
        AppRouter(),
      )

      /// Databases and storages
      ..registerSingletonAsync<ILocalDatabase>(() async {
        final _db = SqfliteLocalDatabase(
          SqfliteDatabaseFacade(
            SqfliteDatabaseProvider(),
          ),
        );

        await _db.initialize();

        return _db;
      })

      /// Local providers
      ..registerSingletonWithDependencies<ITransactionsLocalProvider>(
        () => LocalDbTransactionLocalProvider(
          database: getIt<ILocalDatabase>(),
        ),
        dependsOn: [ILocalDatabase],
      )
      ..registerSingletonWithDependencies<ICategoriesLocalProvider>(
        () => LocalDbCategoriesLocalProvider(
          database: getIt<ILocalDatabase>(),
        ),
        dependsOn: [ILocalDatabase],
      )
      ..registerSingletonWithDependencies<IAppSettingsLocalProvider>(
        () => HiveAppSettingsLocalProvider(
          getIt<HiveFacade>(),
        ),
        dependsOn: [HiveFacade],
      )

      /// Remote providers

      /// Repositories
      ..registerSingleton<ICategoriesRepository>(
        CategoriesRepository(
          localProvider: getIt<ICategoriesLocalProvider>(),
        ),
      )
      ..registerSingleton<ITransactionsRepository>(
        TransactionsRepository(
          localProvider: getIt<ITransactionsLocalProvider>(),
        ),
      )
      ..registerSingleton<IAppSettingsRepository>(
        AppSettingsRepository(
          getIt<IAppSettingsLocalProvider>(),
        ),
      )

      /// Use cases
      ..registerSingleton<ITransactionsCase>(
        TransactionsCaseImpl(
          transactionsRepository: getIt<ITransactionsRepository>(),
        ),
      )
      ..registerSingleton<ICategoriesCase>(
        CategoriesCaseImpl(
          categoriesRepository: getIt<ICategoriesRepository>(),
        ),
      )
      ..registerSingleton<IAppSettingsCase>(
        AppSettingsCaseImpl(
          getIt<IAppSettingsRepository>(),
        ),
      )

      /// Services
      ..registerSingleton<DataExportHandler>(
        DataExportHandler(
          transactionsRepository: getIt<ITransactionsRepository>(),
          categoriesRepository: getIt<ICategoriesRepository>(),
        ),
      )
      ..registerSingleton<DataImportHandler>(
        DataImportHandler(
          transactionsCase: getIt<ITransactionsCase>(),
          categoriesCase: getIt<ICategoriesCase>(),
        ),
      )

      /// Cubits
      ..registerSingleton<CategoryListCubit>(
        CategoryListCubit(
          categoriesCaseImpl: getIt<ICategoriesCase>(),
        ),
      )
      ..registerSingleton<AppSettingsCubit>(
        AppSettingsCubit(
          appSettingsCase: getIt<IAppSettingsCase>(),
        ),
      )
      ..registerFactory<ExportCubit>(
        () => ExportCubit(
          getIt<DataExportHandler>(),
        ),
      )
      ..registerFactory<ImportCubit>(
        () => ImportCubit(
          getIt<DataImportHandler>(),
        ),
      );

    await getIt.allReady();
  }
}
