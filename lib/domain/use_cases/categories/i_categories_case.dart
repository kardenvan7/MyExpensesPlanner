import 'package:my_expenses_planner/domain/models/categories_change_data.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';

abstract class ICategoriesCase {
  Future<List<TransactionCategory>> getCategories();

  Future<void> save(TransactionCategory category);
  Future<void> update(String uuid, TransactionCategory newCategory);
  Future<void> delete(String uuid);

  Stream<CategoriesChangeData> get stream;
}
