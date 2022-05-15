import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';

class CategoriesChangeData {
  CategoriesChangeData({
    List<TransactionCategory>? addedCategories,
    List<TransactionCategory>? editedCategories,
    List<String>? deletedCategoriesUuids,
  })  : addedCategories = addedCategories ?? [],
        editedCategories = editedCategories ?? [],
        deletedCategoriesUuids = deletedCategoriesUuids ?? [];

  final List<TransactionCategory> addedCategories;
  final List<TransactionCategory> editedCategories;
  final List<String> deletedCategoriesUuids;
}
