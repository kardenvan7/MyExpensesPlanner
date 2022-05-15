import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';

class FakeCategoriesRepository implements ICategoriesRepository {
  final Map<String, TransactionCategory> _storage = {};

  @override
  Future<Result<FetchFailure, void>> delete(String uuid) async {
    return Future.sync(
      () {
        _storage.remove(uuid);
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>>
      getCategories() async {
    return Future.value(Result.success(_storage.values.toList()));
  }

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    return Future.sync(
      () {
        if (_storage.containsKey(uuid)) {
          return Result.success(_storage[uuid]!);
        } else {
          return Result.failure(FetchFailure.notFound());
        }
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> save(TransactionCategory category) async {
    return Future.sync(
      () {
        _storage[category.uuid] = category;
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple(
    List<TransactionCategory> categories,
  ) async {
    return Future.sync(
      () {
        for (final TransactionCategory category in categories) {
          _storage[category.uuid] = category;
        }

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> update(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    return Future.sync(
      () {
        _storage[uuid] = newCategory;

        return Result.success(null);
      },
    );
  }
}
