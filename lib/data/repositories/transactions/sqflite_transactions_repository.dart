import 'package:collection/collection.dart';

import '../../local_db/config.dart';
import '../../local_db/database_wrapper.dart';
import '../../local_db/sqflite_local_db.dart';
import '../../models/transaction.dart';
import '../../models/transaction_category.dart';
import '../../repositories/categories/sqflite_categories_repository.dart';
import '../../repositories/transactions/i_transactions_repository.dart';

class SqfliteTransactionsRepository implements ITransactionsRepository {
  SqfliteTransactionsRepository({
    required SqfliteCategoriesRepository categoriesRepository,
    required DatabaseWrapper dbWrapper,
  })  : _categoriesRepository = categoriesRepository,
        _dbWrapper = dbWrapper;

  static const String _tableName = SqfliteDbConfig.transactionsTableName;

  final DatabaseWrapper _dbWrapper;
  final SqfliteCategoriesRepository _categoriesRepository;

  @override
  Future<List<Transaction>> getTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    final List<Map<String, Object?>> transactionsMapsList =
        await _dbWrapper.rawQuery(
      'SELECT * FROM $_tableName '
      'ORDER BY date DESC LIMIT $offset, $limit;',
    );

    final List<TransactionCategory> categoriesList =
        await _categoriesRepository.getCategories();

    final List<Transaction> transactions = [];

    for (final Map<String, Object?> transactionMap in transactionsMapsList) {
      final TransactionCategory? category = categoriesList.firstWhereOrNull(
        (element) =>
            element.uuid ==
            transactionMap[TransactionsTableColumns.categoryUuid.code],
      );

      transactions.add(
        _getTransactionFromDbMapAndCategory(
          map: transactionMap,
          category: category,
        ),
      );
    }

    return transactions;
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    final Map<String, Object?> transactionMap =
        _getTransactionMapForDb(newTransaction);

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
    required Transaction transaction,
  }) async {
    final int id = await _dbWrapper.insert(
      _tableName,
      _getTransactionMapForDb(transaction),
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

  Map<String, Object?> _getTransactionMapForDb(Transaction transaction) {
    final Map<String, Object?> transactionMap = transaction.toMap();

    transactionMap[TransactionsTableColumns.categoryUuid.code] =
        transaction.category?.uuid;

    transactionMap.remove('category');

    return transactionMap;
  }

  Transaction _getTransactionFromDbMapAndCategory({
    required Map<String, Object?> map,
    required TransactionCategory? category,
  }) {
    final Map<String, Object?> newMap = Map.from(map);

    newMap['category'] = category?.toMap();
    newMap.remove(TransactionsTableColumns.categoryUuid.code);

    return Transaction.fromMap(newMap);
  }

  @override
  Future<List<Transaction>> getTransactionsFromPeriod({
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    String _query = 'SELECT * FROM $_tableName '
        'WHERE ${TransactionsTableColumns.date} >= ${startDate.millisecondsSinceEpoch}';

    if (endDate != null) {
      _query +=
          ' AND ${TransactionsTableColumns.date} < ${endDate.millisecondsSinceEpoch}';
    }

    _query += ';';

    final List<Map<String, dynamic>> _transactionsJsonList =
        await _dbWrapper.rawQuery(_query);

    return List.generate(
      _transactionsJsonList.length,
      (index) => Transaction.fromMap(
        _transactionsJsonList[index],
      ),
    );
  }
}
