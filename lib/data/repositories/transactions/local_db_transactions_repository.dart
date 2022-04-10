import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';

class LocalDbTransactionsRepository implements ITransactionsRepository {
  LocalDbTransactionsRepository({
    required ILocalDatabase localDatabase,
  }) : _database = localDatabase;

  final ILocalDatabase _database;

  @override
  Future<List<domain.Transaction>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    domain.TransactionType? type,
  }) async {
    final List<Transaction> dataTransactions = await _database.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
      type: type == null ? null : TransactionTypeFactory.fromName(type.name),
    );

    return List.generate(
      dataTransactions.length,
      (index) => dataTransactions[index].toDomainTransaction(),
    );
  }

  @override
  Future<void> edit({
    required String transactionId,
    required domain.Transaction newTransaction,
  }) async {
    await _database.updateTransaction(
      transactionId,
      Transaction.fromDomainTransaction(newTransaction),
    );
  }

  @override
  Future<void> save({
    required domain.Transaction transaction,
  }) async {
    await _database.insertTransaction(
      Transaction.fromDomainTransaction(transaction),
    );
  }

  @override
  Future<void> delete({
    required String transactionId,
  }) async {
    await _database.deleteTransaction(transactionId);
  }

  @override
  Future<void> saveMultiple({
    required List<domain.Transaction> transactions,
  }) async {
    await _database.insertMultipleTransactions(
      List.generate(
        transactions.length,
        (index) => Transaction.fromDomainTransaction(transactions[index]),
      ),
    );
  }

  @override
  Future<void> deleteAll() async {
    await _database.deleteAllTransactions();
  }
}
