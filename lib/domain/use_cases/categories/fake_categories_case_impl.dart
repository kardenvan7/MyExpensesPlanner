import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/categories/categories_change_data.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

class FakeCategoriesCaseImpl implements ICategoriesCase {
  @override
  Future<Result<FetchFailure, void>> delete(String uuid) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, void>> save(TransactionCategory category) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, void>> update(
    String uuid,
    TransactionCategory newCategory,
  ) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  // TODO: implement stream
  Stream<Result<FetchFailure, CategoriesChangeData>> get stream =>
      throw UnimplementedError();

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) {
    // TODO: implement getCategoryByUuid
    throw UnimplementedError();
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple(
    List<TransactionCategory> category,
  ) {
    // TODO: implement saveMultiple
    throw UnimplementedError();
  }
}
