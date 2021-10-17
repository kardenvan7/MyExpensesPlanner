import 'package:my_expenses_planner/models/transaction.dart';

abstract class ITransactionsProvider {
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  });

  Future<void> save({required Transaction transaction});

  Future<void> edit({
    required String txId,
    required Transaction newTransaction,
  });

  Future<void> delete({required String txId});
}
