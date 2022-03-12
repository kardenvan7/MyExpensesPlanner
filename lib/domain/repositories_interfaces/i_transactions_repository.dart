import 'package:flutter/material.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';

abstract class ITransactionsRepository {
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
  });

  Future<List<Transaction>> getTransactionsFromPeriod({
    required DateTime startDate,
    DateTime? endDate,
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
