import 'package:flutter/material.dart';
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
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    domain.TransactionType? type,
  }) async {
    String _query = 'SELECT * FROM $_tableName ';

    if (dateTimeRange != null) {
      _query += 'WHERE ${TransactionsTableColumns.date.code} '
          '>= ${dateTimeRange.start.millisecondsSinceEpoch} '
          'AND ${TransactionsTableColumns.date.code} <= ${dateTimeRange.end.millisecondsSinceEpoch}';
    }

    if (categoryUuid != null) {
      if (dateTimeRange != null) {
        _query +=
            ' AND ${TransactionsTableColumns.categoryUuid.code} = $categoryUuid';
      } else {
        _query +=
            ' WHERE ${TransactionsTableColumns.categoryUuid.code} = $categoryUuid';
      }
    }

    if (type != null) {
      if (categoryUuid == null && dateTimeRange == null) {
        _query +=
            ' WHERE ${TransactionsTableColumns.type.code} = "${type.name}"';
      } else {
        _query += ' AND ${TransactionsTableColumns.type.code} = "${type.name}"';
      }
    }

    _query += ' ORDER BY ${TransactionsTableColumns.date.code} DESC';

    if (limit != null && offset != null) {
      _query += ' LIMIT $limit OFFSET $offset';
    }

    _query += ';';

    final List<Map<String, Object?>> transactionsMapsList =
        await _dbWrapper.rawQuery(_query);

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
  Future<void> saveMultiple({
    required List<domain.Transaction> transactions,
  }) async {
    String _queryString = 'INSERT OR REPLACE INTO $_tableName '
        '('
        '${TransactionsTableColumns.uuid.code}, '
        '${TransactionsTableColumns.title.code}, '
        '${TransactionsTableColumns.amount.code}, '
        '${TransactionsTableColumns.date.code}, '
        '${TransactionsTableColumns.categoryUuid.code}, '
        '${TransactionsTableColumns.type.code}'
        ')'
        ' VALUES ';

    for (final _tr in transactions) {
      _queryString += ''
          '('
          '"${_tr.uuid}", "${_tr.title}", ${_tr.amount}, '
          '${_tr.date.millisecondsSinceEpoch}, ${_tr.categoryUuid}, '
          '"${_tr.type.name}"'
          '), ';
    }

    _queryString = _queryString.substring(0, _queryString.length - 2);
    _queryString += ';';

    final int id = await _dbWrapper.rawInsert(
      sql: _queryString,
    );

    if (id == 0) {
      throw const FormatException('Saving multiple transactions failed');
    }
  }

  @override
  Future<void> deleteAll() async {
    final int id = await _dbWrapper.delete(_tableName);

    if (id == 0) {
      throw const FormatException('Deleting all transactions failed');
    }
  }
}
