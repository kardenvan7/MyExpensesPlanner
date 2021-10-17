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
        txId: DateTime.now().microsecondsSinceEpoch.toString(),
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
  Future<void> save({required Transaction transaction}) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> edit({
    required String txId,
    required Transaction newTransaction,
  }) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required String txId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
