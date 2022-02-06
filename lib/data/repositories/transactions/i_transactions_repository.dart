import 'package:my_expenses_planner/data/models/transaction.dart';

abstract class ITransactionsRepository {
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  });

  Future<List<Transaction>> getTransactionsFromPeriod({
    required DateTime startDate,
    DateTime? endDate,
  });

  Future<void> save({required Transaction transaction});

  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  });

  Future<void> delete({required String transactionId});
}
