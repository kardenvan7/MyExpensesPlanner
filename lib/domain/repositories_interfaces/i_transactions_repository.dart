import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';

abstract class ITransactionsRepository {
  Future<List<Transaction>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  });

  Future<void> save({required Transaction transaction});
  Future<void> saveMultiple({required List<Transaction> transactions});

  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  });

  Future<void> delete({required String transactionId});
  Future<void> deleteAll();
}
