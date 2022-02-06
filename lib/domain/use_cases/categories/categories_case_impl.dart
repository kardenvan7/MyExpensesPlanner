import 'package:my_expenses_planner/data/models/transaction_category.dart'
    as data;
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';

import '../../models/transaction_category.dart';
import '../../use_cases/categories/i_categories_case.dart';

class CategoriesCaseImpl implements ICategoriesCase {
  CategoriesCaseImpl({
    required ICategoriesRepository categoriesRepository,
  }) : _categoriesRepository = categoriesRepository;

  final ICategoriesRepository _categoriesRepository;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    final List<data.TransactionCategory> _categories =
        await _categoriesRepository.getCategories();

    return List.generate(
      _categories.length,
      (index) => TransactionCategory.fromDataTransactionCategory(
        _categories[index],
      ),
    );
  }

  @override
  Future<void> save(TransactionCategory category) async {
    _categoriesRepository.save(
      category.toDataTransactionCategory(),
    );
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    _categoriesRepository.update(
      uuid,
      newCategory.toDataTransactionCategory(),
    );
  }

  @override
  Future<void> delete(String uuid) async {
    _categoriesRepository.delete(uuid);
  }
}
