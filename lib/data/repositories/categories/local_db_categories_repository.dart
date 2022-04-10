import 'package:my_expenses_planner/data/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart'
    as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';

class SqfliteCategoriesRepository implements ICategoriesRepository {
  SqfliteCategoriesRepository(this._database);

  final ILocalDatabase _database;

  @override
  Future<List<domain.TransactionCategory>> getCategories() async {
    final List<TransactionCategory> _dataCategories =
        await _database.getCategories();

    return List.generate(
      _dataCategories.length,
      (index) => _dataCategories[index].toDomainCategory(),
    );
  }

  @override
  Future<domain.TransactionCategory?> getCategoryByUuid(String uuid) async {
    final TransactionCategory? _dataCategory =
        await _database.getCategoryByUuid(uuid);

    return _dataCategory?.toDomainCategory();
  }

  @override
  Future<void> save(domain.TransactionCategory category) async {
    await _database.insertCategory(
      TransactionCategory.fromDomainCategory(category),
    );
  }

  @override
  Future<void> saveMultiple(List<domain.TransactionCategory> categories) async {
    await _database.insertMultipleCategories(
      List.generate(
        categories.length,
        (index) => TransactionCategory.fromDomainCategory(categories[index]),
      ),
    );
  }

  @override
  Future<void> update(
    String uuid,
    domain.TransactionCategory newCategory,
  ) async {
    await _database.updateCategory(
      uuid,
      TransactionCategory.fromDomainCategory(newCategory),
    );
  }

  @override
  Future<void> delete(String uuid) async {
    await _database.deleteCategory(uuid);
  }
}
