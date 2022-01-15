import 'package:my_expenses_planner/domain/models/transaction.dart';

abstract class ITransactionsRepository {
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  });

  Future<void> save({required Transaction transaction});

  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  });

  Future<void> delete({required String transactionId});
}
