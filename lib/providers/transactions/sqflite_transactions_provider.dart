import 'package:my_expenses_planner/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/providers/transactions/transactions_provider.dart';

class SqfliteTransactionsProvider implements ITransactionsProvider {
  final SqfliteDatabaseProvider _dbProvider = SqfliteDatabaseProvider();
  static const String tableName = 'transactions';

  @override
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    final List<Map<String, Object?>> transactionsMapsList =
        await _dbProvider.database.rawQuery(
      'SELECT * FROM $tableName ORDER BY date DESC LIMIT $offset, $limit',
    );

    final List<Transaction> transactions = [];

    for (final Map<String, Object?> transactionMap in transactionsMapsList) {
      transactions.add(Transaction.fromJson(transactionMap));
    }

    return transactions;
  }

  @override
  Future<void> edit({
    required String txId,
    required Transaction newTransaction,
  }) async {
    final int rowsChangedCount = await _dbProvider.database.update(
      tableName,
      newTransaction.toMap(),
      where: '${TransactionsTableColumns.txId.code} = $txId',
    );

    if (rowsChangedCount == 0) {
      print('Editing transaction $txId failed');
      throw FormatException('Editing transaction $txId failed');
    }
  }

  @override
  Future<void> save({
    required Transaction transaction,
  }) async {
    final int id = await _dbProvider.database.insert(
      tableName,
      transaction.toMap(),
    );

    if (id == 0) {
      print('Saving transaction $id failed');
      throw FormatException('Saving transaction $id failed');
    }
  }

  @override
  Future<void> delete({required String txId}) async {
    final int rowsDeletedCount = await _dbProvider.database.delete(
      tableName,
      where: '${TransactionsTableColumns.txId.code} = $txId',
    );

    if (rowsDeletedCount == 0) {
      print('Deleting transaction $txId failed');
      throw FormatException('Deleting transaction $txId failed');
    }
  }
}
