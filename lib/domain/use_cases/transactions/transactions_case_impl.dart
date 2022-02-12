import 'dart:async';

import 'package:my_expenses_planner/data/models/transaction.dart' as data;
import 'package:my_expenses_planner/data/repositories/transactions/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
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
  }) async {
    final List<data.Transaction> _transactions =
        await _transactionsRepository.getTransactions(
      limit: limit,
      offset: offset,
    );

    return List.generate(
      _transactions.length,
      (index) => Transaction.fromDataTransaction(
        _transactions[index],
      ),
    );
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    _transactionsRepository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction.toDataTransaction(),
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
      transaction: transaction.toDataTransaction(),
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

    final List<data.Transaction> _transactions =
        await _transactionsRepository.getTransactionsFromPeriod(
      startDate: _startDate,
    );

    return List.generate(
      _transactions.length,
      (index) => Transaction.fromDataTransaction(
        _transactions[index],
      ),
    );
  }
}
