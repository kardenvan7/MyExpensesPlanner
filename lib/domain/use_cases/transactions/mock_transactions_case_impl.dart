import 'dart:math';

import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class MockTransactionsCaseImpl implements ITransactionsCase {
  @override
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    return List.generate(
      limit,
      (index) => Transaction(
        uuid: DateTime.now().microsecondsSinceEpoch.toString(),
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
    required String transactionId,
    required Transaction newTransaction,
  }) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required String transactionId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getLastWeekTransactions() {
    // TODO: implement getLastWeekTransactions
    throw UnimplementedError();
  }
}
