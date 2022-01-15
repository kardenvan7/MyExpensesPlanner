import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

class MockCategoriesCaseImpl implements ICategoriesCase {
  @override
  Future<void> delete(String uuid) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionCategory>> getCategories() {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<void> save(TransactionCategory category) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
