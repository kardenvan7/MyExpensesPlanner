import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';

class FakeLocalDatabase implements ILocalDatabase {
  final Map<String, Transaction> _transactions = {};
  final Map<String, TransactionCategory> _categories = {};

  @override
  Future<void> initialize() async {
    await Future.microtask(() => null);
  }

  /// Transactions

  @override
  Future<Result<FetchFailure, void>> insertTransaction(
      Transaction transaction) async {
    return Future.sync(
      () {
        _transactions[transaction.uuid] = transaction;
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> insertMultipleTransactions(
    List<Transaction> transactions,
  ) async {
    return Future.sync(() {
      for (final Transaction transaction in transactions) {
        _transactions[transaction.uuid] = transaction;
      }

      return Result.success(null);
    });
  }

  @override
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) async {
    final _start = offset ?? 0;
    final _end = (offset ?? 0) + (limit ?? 0);

    final List<Transaction> _valuesToTakeFrom = _transactions.values
        .toList()
        .getRange(_start, _end != 0 ? _end : _transactions.values.length)
        .toList();

    final List<Transaction> _filteredValues = _valuesToTakeFrom.where(
      (element) {
        final bool isDateFit = dateTimeRange == null
            ? true
            : element.date.isWithinRange(dateTimeRange);

        final bool isCategoryFit =
            categoryUuid == null ? true : element.categoryUuid == categoryUuid;

        final bool isTypeFit = type == null ? true : element.type == type;

        return isDateFit && isCategoryFit && isTypeFit;
      },
    ).toList();

    return Future.value(Result.success(_filteredValues));
  }

  @override
  Future<Result<FetchFailure, void>> updateTransaction(
    String uuid,
    Transaction newTransaction,
  ) async {
    return Future.sync(
      () {
        _transactions[uuid] = newTransaction;
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteTransaction(String uuid) async {
    return Future.sync(
      () {
        _transactions.remove(uuid);
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteAllTransactions() async {
    return Future.sync(
      () {
        _transactions.clear();
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> insertCategory(
    TransactionCategory category,
  ) async {
    return Future.sync(
      () {
        _categories[category.uuid] = category;
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> insertMultipleCategories(
    List<TransactionCategory> categories,
  ) async {
    return Future.sync(() {
      for (final TransactionCategory category in categories) {
        _categories[category.uuid] = category;
      }

      return Result.success(null);
    });
  }

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>>
      getCategories() async {
    return Future.value(
      Result.success(_categories.values.toList()),
    );
  }

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    if (_categories.containsKey(uuid)) {
      return Result.success(_categories[uuid]!);
    } else {
      return Result.failure(FetchFailure.notFound());
    }
  }

  @override
  Future<Result<FetchFailure, void>> updateCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    return Future.sync(
      () {
        _categories[uuid] = newCategory;
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteCategory(String uuid) async {
    return Future.sync(
      () {
        _categories.remove(uuid);
        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteAllCategories() async {
    return Future.sync(
      () {
        _categories.clear();
        return Result.success(null);
      },
    );
  }
}
