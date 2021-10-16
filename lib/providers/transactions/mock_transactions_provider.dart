import 'dart:math';

import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/providers/transactions/transactions_provider.dart';

class MockTransactionsProvider implements ITransactionsProvider {
  @override
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    return List.generate(
      limit,
      (index) => Transaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: index * 2,
        title: 'Транзакция $index',
        date: DateTime.now().subtract(
          Duration(
            days: Random().nextInt(1000),
          ),
        ),
      ),
    );
  }

  @override
  Future<List<Transaction>> getTransactionsSince({
    required DateTime date,
  }) async {
    return List.generate(
      7,
      (index) => Transaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: index * 50,
        title: 'Транзакция $index',
        date: DateTime.now().subtract(
          Duration(
            days: index,
          ),
        ),
      ),
    );
  }
}
