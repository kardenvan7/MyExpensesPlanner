import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class TransactionsCaseImpl implements ITransactionsCase {
  TransactionsCaseImpl({
    required ITransactionsRepository transactionsRepository,
  }) : _transactionsRepository = transactionsRepository;

  final ITransactionsRepository _transactionsRepository;
  final StreamController<TransactionsChangeData> streamController =
      StreamController<TransactionsChangeData>.broadcast();
  int streamState = 0;

  @override
  Stream<TransactionsChangeData> get stream => streamController.stream;

  @override
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
  }) async {
    return _transactionsRepository.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
    );
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    _transactionsRepository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction,
    );

    streamController.add(
      TransactionsChangeData(
        editedTransactions: [
          newTransaction,
        ],
      ),
    );
  }

  @override
  Future<void> save({
    required Transaction transaction,
  }) async {
    _transactionsRepository.save(
      transaction: transaction,
    );

    streamController.add(
      TransactionsChangeData(
        addedTransactions: [
          transaction,
        ],
      ),
    );
  }

  @override
  Future<void> delete({
    required String transactionId,
  }) async {
    _transactionsRepository.delete(
      transactionId: transactionId,
    );

    streamController.add(
      TransactionsChangeData(
        deletedTransactionsUuids: [
          transactionId,
        ],
      ),
    );
  }

  @override
  Future<List<Transaction>> getLastWeekTransactions() async {
    final DateTime _now = DateTime.now();
    final DateTime _startDate = DateTime(
      _now.year,
      _now.month,
      _now.day,
    ).subtract(
      const Duration(
        days: 6,
      ),
    );

    return _transactionsRepository.getTransactionsFromPeriod(
      startDate: _startDate,
    );
  }

  @override
  Future<void> saveMultiple({required List<Transaction> transactions}) async {
    await _transactionsRepository.saveMultiple(transactions: transactions);

    streamController.add(
      TransactionsChangeData(
        addedTransactions: transactions,
      ),
    );
  }

  @override
  Future<void> deleteAll() async {
    await _transactionsRepository.deleteAll();

    streamController.add(
      TransactionsChangeData(
        deletedAll: true,
      ),
    );
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
            ),
          );
        },
      );
    }

    await _transactionsRepository.saveMultiple(transactions: _transactions);

    streamController.add(
      TransactionsChangeData(
        addedTransactions: _transactions,
      ),
    );
  }
}
