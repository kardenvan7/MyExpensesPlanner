import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/data/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';

class MockLocalDatabase implements ILocalDatabase {
  final Map<String, Transaction> _transactions = {};
  final Map<String, TransactionCategory> _categories = {};

  @override
  Future<void> initialize() async {
    await Future.microtask(() => null);
  }

  /// Transactions

  @override
  Future<void> insertTransaction(Transaction transaction) async {
    await Future.sync(() => _transactions[transaction.uuid] = transaction);
  }

  @override
  Future<void> insertMultipleTransactions(
    List<Transaction> transactions,
  ) async {
    await Future.sync(() {
      for (final Transaction transaction in transactions) {
        _transactions[transaction.uuid] = transaction;
      }
    });
  }

  @override
  Future<List<Transaction>> getTransactions({
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

    return Future.value(_filteredValues);
  }

  @override
  Future<void> updateTransaction(
    String uuid,
    Transaction newTransaction,
  ) async {
    await Future.sync(() => _transactions[uuid] = newTransaction);
  }

  @override
  Future<void> deleteTransaction(String uuid) async {
    await Future.sync(() => _transactions.remove(uuid));
  }

  @override
  Future<void> deleteAllTransactions() async {
    await Future.sync(() => _transactions.clear());
  }

  @override
  Future<void> insertCategory(TransactionCategory category) async {
    await Future.sync(() => _categories[category.uuid] = category);
  }

  @override
  Future<void> insertMultipleCategories(
    List<TransactionCategory> categories,
  ) async {
    await Future.sync(() {
      for (final TransactionCategory category in categories) {
        _categories[category.uuid] = category;
      }
    });
  }

  @override
  Future<List<TransactionCategory>> getCategories() async {
    return Future.value(_categories.values.toList());
  }

  @override
  Future<TransactionCategory?> getCategoryByUuid(String uuid) {
    return Future.value(_categories[uuid]);
  }

  @override
  Future<void> updateCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    await Future.sync(() => _categories[uuid] = newCategory);
  }

  @override
  Future<void> deleteCategory(String uuid) async {
    await Future.sync(() => _categories.remove(uuid));
  }

  @override
  Future<void> deleteAllCategories() async {
    await Future.sync(() => _categories.clear());
  }
}
