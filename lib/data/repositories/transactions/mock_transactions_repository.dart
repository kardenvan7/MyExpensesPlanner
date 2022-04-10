import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';

class MockTransactionsRepository implements ITransactionsRepository {
  final Map<String, Transaction> _storage = {};

  @override
  Future<void> delete({required String transactionId}) async {
    await Future.sync(() => _storage.remove(transactionId));
  }

  @override
  Future<void> deleteAll() async {
    await Future.sync(() => _storage.clear());
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    await Future.sync(() => _storage[transactionId] = newTransaction);
  }

  @override
  Future<List<Transaction>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) {
    final _start = offset ?? 0;
    final _end = (offset ?? 0) + (limit ?? 0);

    final List<Transaction> _valuesToTakeFrom = _storage.values
        .toList()
        .getRange(_start, _end != 0 ? _end : _storage.values.length)
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
  Future<void> save({required Transaction transaction}) async {
    await Future.sync(() => _storage[transaction.uuid] = transaction);
  }

  @override
  Future<void> saveMultiple({required List<Transaction> transactions}) async {
    await Future.sync(() {
      for (final Transaction transaction in transactions) {
        _storage[transaction.uuid] = transaction;
      }
    });
  }
}
