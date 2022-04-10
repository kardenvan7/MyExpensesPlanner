import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';

class MockCategoriesRepository implements ICategoriesRepository {
  final Map<String, TransactionCategory> _storage = {};

  @override
  Future<void> delete(String uuid) async {
    await Future.sync(() => _storage.remove(uuid));
  }

  @override
  Future<List<TransactionCategory>> getCategories() async {
    return Future.value(_storage.values.toList());
  }

  @override
  Future<TransactionCategory?> getCategoryByUuid(String uuid) async {
    return Future.value(_storage[uuid]);
  }

  @override
  Future<void> save(TransactionCategory category) async {
    await Future.sync(() => _storage[category.uuid] = category);
  }

  @override
  Future<void> saveMultiple(List<TransactionCategory> categories) async {
    await Future.sync(
      () {
        for (final TransactionCategory category in categories) {
          _storage[category.uuid] = category;
        }
      },
    );
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    await Future.sync(() => _storage[uuid] = newCategory);
  }
}
