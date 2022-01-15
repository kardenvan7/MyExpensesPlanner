import 'package:my_expenses_planner/data/repositories/categories/sqflite_categories_repository.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

class CategoriesCaseImpl implements ICategoriesCase {
  CategoriesCaseImpl({
    required SqfliteCategoriesRepository sqfliteCategoriesRepository,
  }) : _sqfliteCategoriesRepository = sqfliteCategoriesRepository;

  final SqfliteCategoriesRepository _sqfliteCategoriesRepository;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    return _sqfliteCategoriesRepository.getCategories();
  }

  @override
  Future<void> save(TransactionCategory category) async {
    _sqfliteCategoriesRepository.save(category);
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    _sqfliteCategoriesRepository.update(uuid, newCategory);
  }

  @override
  Future<void> delete(String uuid) async {
    _sqfliteCategoriesRepository.delete(uuid);
  }
}
