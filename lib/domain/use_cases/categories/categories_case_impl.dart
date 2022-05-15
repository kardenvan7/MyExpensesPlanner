import 'dart:async';

import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

import '../../models/categories/categories_change_data.dart';
import '../../models/categories/transaction_category.dart';
import '../../repositories_interfaces/i_categories_repository.dart';
import '../categories/i_categories_case.dart';

class CategoriesCaseImpl implements ICategoriesCase {
  CategoriesCaseImpl({
    required ICategoriesRepository categoriesRepository,
  }) : _categoriesRepository = categoriesRepository;

  final ICategoriesRepository _categoriesRepository;

  final StreamController<Result<FetchFailure, CategoriesChangeData>>
      _streamController =
      StreamController<Result<FetchFailure, CategoriesChangeData>>.broadcast();

  @override
  Stream<Result<FetchFailure, CategoriesChangeData>> get stream =>
      _streamController.stream;

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>>
      getCategories() async {
    return _categoriesRepository.getCategories();
  }

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    return _categoriesRepository.getCategoryByUuid(uuid);
  }

  @override
  Future<Result<FetchFailure, void>> save(TransactionCategory category) async {
    final _result = await _categoriesRepository.save(
      category,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        _streamController.add(
          Result.success(
            CategoriesChangeData(
              addedCategories: [category],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple(
    List<TransactionCategory> categories,
  ) async {
    final _result = await _categoriesRepository.saveMultiple(
      categories,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        _streamController.add(
          Result.success(
            CategoriesChangeData(
              addedCategories: categories,
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> update(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    final _result = await _categoriesRepository.update(
      uuid,
      newCategory,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        _streamController.add(
          Result.success(
            CategoriesChangeData(
              editedCategories: [newCategory],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete(String uuid) async {
    final _result = await _categoriesRepository.delete(uuid);

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        _streamController.add(
          Result.success(
            CategoriesChangeData(
              deletedCategoriesUuids: [uuid],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }
}
