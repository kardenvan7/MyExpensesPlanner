import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';

abstract class ITransactionsCase {
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  });

  Future<List<Transaction>> getLastWeekTransactions();

  Future<void> save({required Transaction transaction});
  Future<void> saveMultiple({required List<Transaction> transactions});

  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  });

  Future<void> delete({required String transactionId});

  Stream<TransactionsChangeData> get stream;
}
