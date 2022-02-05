import 'package:my_expenses_planner/data/models/transaction_category.dart'
    as data;
import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';

import '../../models/transaction_category.dart';
import '../../use_cases/categories/i_categories_case.dart';

class CategoriesCaseImpl implements ICategoriesCase {
  CategoriesCaseImpl({
    required SqfliteCategoriesRepository sqfliteCategoriesRepository,
  }) : _sqfliteCategoriesRepository = sqfliteCategoriesRepository;

  final SqfliteCategoriesRepository _sqfliteCategoriesRepository;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    final List<data.TransactionCategory> _categories =
        await _sqfliteCategoriesRepository.getCategories();

    return List.generate(
      _categories.length,
      (index) => TransactionCategory.fromDataTransactionCategory(
        _categories[index],
      ),
    );
  }

  @override
  Future<void> save(TransactionCategory category) async {
    _sqfliteCategoriesRepository.save(
      category.toDataTransactionCategory(),
    );
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    _sqfliteCategoriesRepository.update(
      uuid,
      newCategory.toDataTransactionCategory(),
    );
  }

  @override
  Future<void> delete(String uuid) async {
    _sqfliteCategoriesRepository.delete(uuid);
  }
}
