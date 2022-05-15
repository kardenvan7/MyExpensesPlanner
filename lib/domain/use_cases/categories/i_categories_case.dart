import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/categories/categories_change_data.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';

abstract class ICategoriesCase {
  Future<Result<FetchFailure, List<TransactionCategory>>> getCategories();
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  );

  Future<Result<FetchFailure, void>> save(TransactionCategory category);
  Future<Result<FetchFailure, void>> saveMultiple(
    List<TransactionCategory> categories,
  );
  Future<Result<FetchFailure, void>> update(
    String uuid,
    TransactionCategory newCategory,
  );
  Future<Result<FetchFailure, void>> delete(String uuid);

  Stream<Result<FetchFailure, CategoriesChangeData>> get stream;
}
