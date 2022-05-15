import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/local/providers/categories/i_categories_local_provider.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

class LocalDbCategoriesLocalProvider implements ICategoriesLocalProvider {
  LocalDbCategoriesLocalProvider({
    required ILocalDatabase database,
  }) : _database = database;

  final ILocalDatabase _database;

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>>
      getCategories() async {
    return _database.getCategories();
  }

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    return _database.getCategoryByUuid(uuid);
  }

  @override
  Future<Result<FetchFailure, void>> save(TransactionCategory category) async {
    return _database.insertCategory(category);
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple(
    List<TransactionCategory> categories,
  ) async {
    return _database.insertMultipleCategories(
      List.generate(
        categories.length,
        (index) => categories[index],
      ),
    );
  }

  @override
  Future<Result<FetchFailure, void>> update(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    return _database.updateCategory(
      uuid,
      newCategory,
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete(String uuid) async {
    return _database.deleteCategory(uuid);
  }
}
