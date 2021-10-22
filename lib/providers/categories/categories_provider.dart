import 'package:my_expenses_planner/models/transaction_category.dart';

abstract class ICategoriesProvider {
  Future<List<TransactionCategory>> getCategories();
  Future<void> save(TransactionCategory category);
}
