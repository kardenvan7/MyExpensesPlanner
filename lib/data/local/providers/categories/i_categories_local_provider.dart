import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

abstract class ICategoriesLocalProvider {
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
}
