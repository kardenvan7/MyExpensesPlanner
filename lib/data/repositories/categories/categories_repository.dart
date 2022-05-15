import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/providers/categories/i_categories_local_provider.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart'
    as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';

class CategoriesRepository implements ICategoriesRepository {
  CategoriesRepository({
    required ICategoriesLocalProvider localProvider,
  }) : _localProvider = localProvider;

  final ICategoriesLocalProvider _localProvider;

  @override
  Future<Result<FetchFailure, List<domain.TransactionCategory>>>
      getCategories() async {
    final _fetchResult = await _localProvider.getCategories();

    return _fetchResult.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (categories) {
        return Result.success(
          List.generate(
            categories.length,
            (index) => categories[index].toDomainCategory(),
          ),
        );
      },
    );
  }

  @override
  Future<Result<FetchFailure, domain.TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    final _result = await _localProvider.getCategoryByUuid(uuid);

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (category) {
        return Result.success(category.toDomainCategory());
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> save(
    domain.TransactionCategory category,
  ) async {
    return _localProvider.save(
      TransactionCategory.fromDomainCategory(category),
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple(
    List<domain.TransactionCategory> categories,
  ) async {
    return _localProvider.saveMultiple(
      List.generate(
        categories.length,
        (index) => TransactionCategory.fromDomainCategory(categories[index]),
      ),
    );
  }

  @override
  Future<Result<FetchFailure, void>> update(
    String uuid,
    domain.TransactionCategory newCategory,
  ) async {
    return _localProvider.update(
      uuid,
      TransactionCategory.fromDomainCategory(newCategory),
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete(String uuid) async {
    return _localProvider.delete(uuid);
  }
}
