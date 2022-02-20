import 'package:my_expenses_planner/domain/models/transaction_category.dart';

abstract class ICategoriesRepository {
  Future<List<TransactionCategory>> getCategories();
  Future<TransactionCategory?> getCategoryByUuid(String uuid);

  Future<void> save(TransactionCategory category);
  Future<void> update(String uuid, TransactionCategory newCategory);
  Future<void> delete(String uuid);
}
