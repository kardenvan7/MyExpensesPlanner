import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/local_db/i_local_db.dart';
import 'package:my_expenses_planner/data/local/local_db/sqflite/sqflite_config.dart';
import 'package:my_expenses_planner/data/local/local_db/sqflite/sqflite_database_facade.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';

class SqfliteLocalDatabase implements ILocalDatabase {
  SqfliteLocalDatabase(this._databaseFacade);

  final SqfliteDatabaseFacade _databaseFacade;

  static const String _transactionsTableName =
      SqfliteDbConfig.transactionsTableName;

  static const String _categoriesTableName =
      SqfliteDbConfig.categoriesTableName;

  @override
  Future<void> initialize() async {
    await _databaseFacade.initDatabase();
  }

  @override
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) async {
    String _query = 'SELECT * FROM $_transactionsTableName ';

    if (dateTimeRange != null) {
      _query += 'WHERE ${SqfliteTransactionsTableColumns.date.code} '
          '>= ${dateTimeRange.start.millisecondsSinceEpoch} '
          'AND ${SqfliteTransactionsTableColumns.date.code} <= ${dateTimeRange.end.millisecondsSinceEpoch}';
    }

    if (categoryUuid != null) {
      if (dateTimeRange != null) {
        _query +=
            ' AND ${SqfliteTransactionsTableColumns.categoryUuid.code} = $categoryUuid';
      } else {
        _query +=
            ' WHERE ${SqfliteTransactionsTableColumns.categoryUuid.code} = $categoryUuid';
      }
    }

    if (type != null) {
      if (categoryUuid == null && dateTimeRange == null) {
        _query +=
            ' WHERE ${SqfliteTransactionsTableColumns.type.code} = "${type.name}"';
      } else {
        _query +=
            ' AND ${SqfliteTransactionsTableColumns.type.code} = "${type.name}"';
      }
    }

    _query += ' ORDER BY ${SqfliteTransactionsTableColumns.date.code} DESC';

    if (limit != null && offset != null) {
      _query += ' LIMIT $limit OFFSET $offset';
    }

    _query += ';';

    try {
      final List<Map<String, Object?>> transactionsMapsList =
          await _databaseFacade.rawQuery(_query);

      final List<Transaction> transactions = [];

      for (final Map<String, Object?> transactionMap in transactionsMapsList) {
        transactions.add(
          Transaction.fromMap(transactionMap),
        );
      }

      return Result.success(transactions);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> insertTransaction(
    Transaction transaction,
  ) async {
    try {
      final int id = await _databaseFacade.insert(
        _transactionsTableName,
        _getTransactionMapForDb(transaction),
      );

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> insertMultipleTransactions(
    List<Transaction> transactions,
  ) async {
    String _queryString = 'INSERT OR REPLACE INTO $_transactionsTableName '
        '('
        '${SqfliteTransactionsTableColumns.uuid.code}, '
        '${SqfliteTransactionsTableColumns.title.code}, '
        '${SqfliteTransactionsTableColumns.amount.code}, '
        '${SqfliteTransactionsTableColumns.date.code}, '
        '${SqfliteTransactionsTableColumns.categoryUuid.code}, '
        '${SqfliteTransactionsTableColumns.type.code}'
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

    try {
      final int id = await _databaseFacade.rawInsert(
        sql: _queryString,
      );

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> updateTransaction(
    String uuid,
    Transaction newTransaction,
  ) async {
    final Map<String, dynamic> transactionMap = newTransaction.toMap();

    try {
      final int rowsChangedCount = await _databaseFacade.update(
        _transactionsTableName,
        transactionMap,
        where: '${SqfliteTransactionsTableColumns.uuid.code} = $uuid',
      );

      if (rowsChangedCount == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> deleteTransaction(String uuid) async {
    try {
      final int rowsDeletedCount = await _databaseFacade.delete(
        _transactionsTableName,
        where: '${SqfliteTransactionsTableColumns.uuid.code} = $uuid',
      );

      if (rowsDeletedCount == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> deleteAllTransactions() async {
    try {
      final int id = await _databaseFacade.delete(_transactionsTableName);

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  Map<String, dynamic> _getTransactionMapForDb(Transaction transaction) {
    return <String, dynamic>{
      SqfliteTransactionsTableColumns.uuid.code: transaction.uuid,
      SqfliteTransactionsTableColumns.title.code: transaction.title,
      SqfliteTransactionsTableColumns.date.code:
          transaction.date.millisecondsSinceEpoch,
      SqfliteTransactionsTableColumns.type.code: transaction.type.name,
      SqfliteTransactionsTableColumns.categoryUuid.code:
          transaction.categoryUuid,
    };
  }

  @override
  Future<Result<FetchFailure, void>> insertCategory(
    TransactionCategory category,
  ) async {
    try {
      final int id = await _databaseFacade.insert(
        _categoriesTableName,
        _getCategoryMapForDb(category),
      );

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> insertMultipleCategories(
    List<TransactionCategory> categories,
  ) async {
    String _queryString = 'INSERT OR REPLACE INTO $_categoriesTableName '
        '('
        '${SqfliteCategoriesTableColumns.uuid.code}, '
        '${SqfliteCategoriesTableColumns.color.code}, '
        '${SqfliteCategoriesTableColumns.name.code}'
        ')'
        ' VALUES ';

    for (final _category in categories) {
      _queryString += ''
          '('
          '"${_category.uuid}", '
          '"${_category.color.toHexString()}", '
          '"${_category.name}"'
          '), ';
    }

    _queryString = _queryString.substring(0, _queryString.length - 2);
    _queryString += ';';

    try {
      final int id = await _databaseFacade.rawInsert(
        sql: _queryString,
      );

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, List<TransactionCategory>>>
      getCategories() async {
    try {
      final List<Map<String, dynamic>> categoriesMapList =
          await _databaseFacade.rawQuery(
        'SELECT *'
        'FROM $_categoriesTableName',
      );

      final List<TransactionCategory> categoriesList = [];

      for (final Map<String, dynamic> categoryMap in categoriesMapList) {
        categoriesList.add(
          TransactionCategory.fromMap(categoryMap),
        );
      }

      return Result.success(categoriesList);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
    String uuid,
  ) async {
    try {
      final List<Map<String, dynamic>> _categoryMapList =
          await _databaseFacade.rawQuery(
        'SELECT * FROM $_categoriesTableName '
        'WHERE ${SqfliteCategoriesTableColumns.uuid.code} = $uuid '
        'LIMIT 1',
      );

      if (_categoryMapList.isEmpty) {
        return Result.failure(FetchFailure.notFound());
      }

      return Result.success(
        TransactionCategory.fromMap(_categoryMapList.first),
      );
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> updateCategory(
    String uuid,
    TransactionCategory newCategory,
  ) async {
    try {
      final Map<String, Object?> newCategoryMap = _getCategoryMapForDb(
        newCategory,
      );

      final int rowsChangedCount = await _databaseFacade.update(
        _categoriesTableName,
        newCategoryMap,
        where: '${SqfliteCategoriesTableColumns.uuid.code} = $uuid',
      );

      if (rowsChangedCount == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> deleteCategory(String uuid) async {
    try {
      final int _rowsChangedCount = await _databaseFacade.update(
        SqfliteDbConfig.transactionsTableName,
        {SqfliteTransactionsTableColumns.categoryUuid.code: null},
        where: '${SqfliteTransactionsTableColumns.categoryUuid.code} = $uuid',
      );

      if (_rowsChangedCount == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      final int rowsDeletedCount = await _databaseFacade.delete(
        _categoriesTableName,
        where: '${SqfliteCategoriesTableColumns.uuid.code} = $uuid',
      );

      if (rowsDeletedCount == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  @override
  Future<Result<FetchFailure, void>> deleteAllCategories() async {
    try {
      final int id = await _databaseFacade.delete(_categoriesTableName);

      if (id == 0) {
        return Result.failure(FetchFailure.unknown());
      }

      return Result.success(null);
    } catch (_) {
      return Result.failure(FetchFailure.unknown());
    }
  }

  Map<String, dynamic> _getCategoryMapForDb(TransactionCategory category) {
    return <String, dynamic>{
      SqfliteCategoriesTableColumns.uuid.code: category.uuid,
      SqfliteCategoriesTableColumns.name.code: category.name,
      SqfliteCategoriesTableColumns.color.code: category.color.toHexString(),
    };
  }
}
