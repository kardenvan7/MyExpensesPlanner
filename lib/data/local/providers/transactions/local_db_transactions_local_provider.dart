import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/local/providers/transactions/i_transactions_local_provider.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

class LocalDbTransactionLocalProvider implements ITransactionsLocalProvider {
  LocalDbTransactionLocalProvider({
    required ILocalDatabase database,
  }) : _database = database;

  final ILocalDatabase _database;

  @override
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) async {
    return _database.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
      type: type == null ? null : TransactionTypeFactory.fromName(type.name),
    );
  }

  @override
  Future<Result<FetchFailure, void>> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    return _database.updateTransaction(
      transactionId,
      newTransaction,
    );
  }

  @override
  Future<Result<FetchFailure, void>> save({
    required Transaction transaction,
  }) async {
    return _database.insertTransaction(transaction);
  }

  @override
  Future<Result<FetchFailure, void>> delete({
    required String transactionId,
  }) async {
    return _database.deleteTransaction(transactionId);
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple({
    required List<Transaction> transactions,
  }) async {
    return _database.insertMultipleTransactions(
      List.generate(
        transactions.length,
        (index) => transactions[index],
      ),
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteAll() async {
    return _database.deleteAllTransactions();
  }
}
