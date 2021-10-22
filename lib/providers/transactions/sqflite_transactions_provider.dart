import 'package:collection/collection.dart';
import 'package:my_expenses_planner/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/providers/categories/sqflite_categories_provider.dart';
import 'package:my_expenses_planner/providers/transactions/transactions_provider.dart';

class SqfliteTransactionsProvider implements ITransactionsProvider {
  final SqfliteDatabaseProvider _dbProvider = SqfliteDatabaseProvider();
  final SqfliteCategoriesProvider _categoriesProvider =
      SqfliteCategoriesProvider();
  final String tableName = transactionsTableName;

  @override
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    final List<Map<String, Object?>> transactionsMapsList =
        await _dbProvider.database.rawQuery(
      'SELECT * FROM $tableName '
      'ORDER BY date DESC LIMIT $offset, $limit;',
    );

    final List<TransactionCategory> categoriesList =
        await _categoriesProvider.getCategories();

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

    final int rowsChangedCount = await _dbProvider.database.update(
      tableName,
      transactionMap,
      where: '${TransactionsTableColumns.uuid.code} = $transactionId',
    );

    if (rowsChangedCount == 0) {
      print('Editing transaction $transactionId failed');
      throw FormatException('Editing transaction $transactionId failed');
    }
  }

  @override
  Future<void> save({
    required Transaction transaction,
  }) async {
    final int id = await _dbProvider.database.insert(
      tableName,
      _getTransactionMapForDb(transaction),
    );

    if (id == 0) {
      print('Saving transaction $id failed');
      throw FormatException('Saving transaction $id failed');
    }
  }

  @override
  Future<void> delete({required String transactionId}) async {
    final int rowsDeletedCount = await _dbProvider.database.delete(
      tableName,
      where: '${TransactionsTableColumns.uuid.code} = $transactionId',
    );

    if (rowsDeletedCount == 0) {
      print('Deleting transaction $transactionId failed');
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
}
