import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/repositories/transactions/fake_transactions_repository.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class FakeTransactionsCaseImpl implements ITransactionsCase {
  final ITransactionsRepository _repository = FakeTransactionsRepository();

  final StreamController<Result<FetchFailure, TransactionsChangeData>>
      streamController = StreamController<
          Result<FetchFailure, TransactionsChangeData>>.broadcast();

  @override
  Stream<Result<FetchFailure, TransactionsChangeData>> get stream =>
      streamController.stream;

  @override
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
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
  Future<Result<FetchFailure, void>> save({
    required Transaction transaction,
  }) async {
    streamController.add(
      Result.success(
        TransactionsChangeData(
          addedTransactions: [transaction],
        ),
      ),
    );

    return _repository.save(transaction: transaction);
  }

  @override
  Future<Result<FetchFailure, void>> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    streamController.add(
      Result.success(
        TransactionsChangeData(
          editedTransactions: [newTransaction],
        ),
      ),
    );

    return _repository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction,
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete({
    required String transactionId,
  }) async {
    streamController.add(
      Result.success(
        TransactionsChangeData(
          deletedTransactionsUuids: [transactionId],
        ),
      ),
    );

    return _repository.delete(transactionId: transactionId);
  }

  @override
  Future<Result<FetchFailure, List<Transaction>>> getLastWeekExpenses() async {
    return _repository.getTransactions(
      dateTimeRange: DateTimeRangeFactory.lastWeek(),
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple({
    required List<Transaction> transactions,
  }) async {
    streamController.add(
      Result.success(
        TransactionsChangeData(
          addedTransactions: transactions,
        ),
      ),
    );

    return _repository.saveMultiple(transactions: transactions);
  }

  @override
  Future<Result<FetchFailure, void>> deleteAll() async {
    streamController.add(
      Result.success(
        TransactionsChangeData(deletedAll: true),
      ),
    );

    return _repository.deleteAll();
  }

  @override
  Future<Result<FetchFailure, void>> fillWithMockTransactions() async {
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

    streamController.add(
      Result.success(
        TransactionsChangeData(
          addedTransactions: _transactions,
        ),
      ),
    );

    return _repository.saveMultiple(transactions: _transactions);
  }
}
