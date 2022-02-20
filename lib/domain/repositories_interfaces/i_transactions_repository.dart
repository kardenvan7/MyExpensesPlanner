import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;

abstract class ITransactionsRepository {
  Future<List<domain.Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  });

  Future<List<domain.Transaction>> getTransactionsFromPeriod({
    required DateTime startDate,
    DateTime? endDate,
  });

  Future<void> save({required domain.Transaction transaction});

  Future<void> edit({
    required String transactionId,
    required domain.Transaction newTransaction,
  });

  Future<void> delete({required String transactionId});
}
