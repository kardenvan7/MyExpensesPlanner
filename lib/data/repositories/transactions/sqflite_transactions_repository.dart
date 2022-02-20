import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;

import '../../../domain/repositories_interfaces/i_transactions_repository.dart';
import '../../local_db/config.dart';
import '../../local_db/database_wrapper.dart';
import '../../local_db/sqflite_local_db.dart';

class SqfliteTransactionsRepository implements ITransactionsRepository {
  SqfliteTransactionsRepository({
    required DatabaseWrapper dbWrapper,
  }) : _dbWrapper = dbWrapper;

  static const String _tableName = SqfliteDbConfig.transactionsTableName;

  final DatabaseWrapper _dbWrapper;

  @override
  Future<List<domain.Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    final List<Map<String, Object?>> transactionsMapsList =
        await _dbWrapper.rawQuery(
      'SELECT * FROM $_tableName '
      'ORDER BY date DESC LIMIT $offset, $limit;',
    );

    final List<domain.Transaction> transactions = [];

    for (final Map<String, Object?> transactionMap in transactionsMapsList) {
      transactions.add(
        domain.Transaction.fromMap(transactionMap),
      );
    }

    return transactions;
  }

  @override
  Future<void> edit({
    required String transactionId,
    required domain.Transaction newTransaction,
  }) async {
    final Map<String, dynamic> transactionMap = newTransaction.toMap();

    final int rowsChangedCount = await _dbWrapper.update(
      _tableName,
      transactionMap,
      where: '${TransactionsTableColumns.uuid.code} = $transactionId',
    );

    if (rowsChangedCount == 0) {
      throw FormatException('Editing transaction $transactionId failed');
    }
  }

  @override
  Future<void> save({
    required domain.Transaction transaction,
  }) async {
    final int id = await _dbWrapper.insert(
      _tableName,
      transaction.toMap(),
    );

    if (id == 0) {
      throw FormatException('Saving transaction $id failed');
    }
  }

  @override
  Future<void> delete({
    required String transactionId,
  }) async {
    final int rowsDeletedCount = await _dbWrapper.delete(
      _tableName,
      where: '${TransactionsTableColumns.uuid.code} = $transactionId',
    );

    if (rowsDeletedCount == 0) {
      throw FormatException('Deleting transaction $transactionId failed');
    }
  }

  @override
  Future<List<domain.Transaction>> getTransactionsFromPeriod({
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    String _query = 'SELECT * FROM $_tableName '
        'WHERE '
        '${TransactionsTableColumns.date.code} '
        '>= ${startDate.millisecondsSinceEpoch}';

    if (endDate != null) {
      _query += ' AND '
          '${TransactionsTableColumns.date.code} '
          '< ${endDate.millisecondsSinceEpoch}';
    }

    _query += ';';

    final List<Map<String, dynamic>> _transactionsJsonList =
        await _dbWrapper.rawQuery(_query);

    return List.generate(
      _transactionsJsonList.length,
      (index) => domain.Transaction.fromMap(
        _transactionsJsonList[index],
      ),
    );
  }
}
