import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/data/repositories/transactions/mock_transactions_repository.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class MockTransactionsCaseImpl implements ITransactionsCase {
  final ITransactionsRepository _repository = MockTransactionsRepository();

  final StreamController<TransactionsChangeData> streamController =
      StreamController<TransactionsChangeData>.broadcast();

  @override
  Stream<TransactionsChangeData> get stream => streamController.stream;

  @override
  Future<List<Transaction>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) async {
    return _repository.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
      type: type,
    );
  }

  @override
  Future<void> save({required Transaction transaction}) async {
    await _repository.save(transaction: transaction);

    streamController.add(
      TransactionsChangeData(
        addedTransactions: [transaction],
      ),
    );
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    await _repository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction,
    );

    streamController.add(
      TransactionsChangeData(
        editedTransactions: [newTransaction],
      ),
    );
  }

  @override
  Future<void> delete({required String transactionId}) async {
    await _repository.delete(transactionId: transactionId);

    streamController.add(
      TransactionsChangeData(
        deletedTransactionsUuids: [transactionId],
      ),
    );
  }

  @override
  Future<List<Transaction>> getLastWeekExpenses() async {
    return _repository.getTransactions(
      dateTimeRange: DateTimeRangeFactory.lastWeek(),
    );
  }

  @override
  Future<void> saveMultiple({required List<Transaction> transactions}) async {
    await _repository.saveMultiple(transactions: transactions);

    streamController.add(
      TransactionsChangeData(
        addedTransactions: transactions,
      ),
    );
  }

  @override
  Future<void> deleteAll() async {
    await _repository.deleteAll();

    streamController.add(TransactionsChangeData(deletedAll: true));
  }

  @override
  Future<void> fillWithMockTransactions() async {
    final List<Transaction> _transactions = [];

    for (int i = 0; i < 40; i++) {
      await Future.delayed(
        const Duration(milliseconds: 200),
        () {
          final DateTime _date = DateTime.now().subtract(
            Duration(hours: 12 * i),
          );

          _transactions.add(
            Transaction(
              uuid: _date.millisecondsSinceEpoch.toString(),
              amount: (i + 1) * 10,
              title: 'Transaction ${i + 1}',
              date: _date,
              type:
                  i % 2 == 0 ? TransactionType.expense : TransactionType.income,
            ),
          );
        },
      );
    }

    await _repository.saveMultiple(transactions: _transactions);

    streamController.add(
      TransactionsChangeData(
        addedTransactions: _transactions,
      ),
    );
  }
}
