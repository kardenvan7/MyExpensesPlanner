import 'package:my_expenses_planner/models/transaction.dart';

abstract class ITransactionsProvider {
  Future<List<Transaction>> getLastTransactions(
      {int limit = 40, int offset = 0});
  Future<List<Transaction>> getTransactionsSince({required DateTime date});
}
