import 'dart:async';

import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseWrapper {
  DatabaseWrapper(this._databaseProvider);

  final SqfliteDatabaseProvider _databaseProvider;

  Future<void> initDatabase() async {
    await _databaseProvider.initDatabase();
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String query, {
    List<Object?>? arguments,
  }) async {
    final List<Map<String, dynamic>> _data =
        await _databaseProvider.database.rawQuery(
      query,
      arguments,
    );

    return _data;
  }

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final int _status = await _databaseProvider.database.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );

    return _status;
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final int _status = await _databaseProvider.database.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );

    return _status;
  }

  Future<int> delete(
    String table, {
    String? where,
    List? whereArgs,
  }) async {
    final int _status = await _databaseProvider.database.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );

    return _status;
  }

  Future<void> deleteDb() async {
    _databaseProvider.delete();
  }

  Future<void> close() async {
    _databaseProvider.close();
  }
}
