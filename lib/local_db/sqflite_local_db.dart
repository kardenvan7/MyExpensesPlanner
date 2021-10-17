import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabaseProvider {
  late final Database database;

  static const String _dbFileName = 'myExpensesPlanner.db';
  static const int _version = 1;
  late final String _myDbPath;

  static final SqfliteDatabaseProvider _instance = SqfliteDatabaseProvider._();

  factory SqfliteDatabaseProvider() {
    return _instance;
  }

  SqfliteDatabaseProvider._();

  Future<void> initDatabase() async {
    final String _databasesPath = await getDatabasesPath();
    _myDbPath = join(_databasesPath, _dbFileName);

    database = await openDatabase(
      _myDbPath,
      version: _version,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE transactions ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${TransactionsTableColumns.txId.code} TEXT, '
          '${TransactionsTableColumns.title.code} TEXT, '
          '${TransactionsTableColumns.amount.code} REAL, '
          '${TransactionsTableColumns.date.code} INT'
          ')',
        );
      },
    );
  }

  Future<void> delete() async {
    await deleteDatabase(_myDbPath);
  }

  Future<void> close() async {
    await database.close();
  }
}

enum TransactionsTableColumns { txId, title, amount, date }

extension ColumnsCodes on TransactionsTableColumns {
  String get code {
    switch (this) {
      case TransactionsTableColumns.txId:
        return 'tx_id';
      case TransactionsTableColumns.title:
        return 'title';
      case TransactionsTableColumns.amount:
        return 'amount';
      case TransactionsTableColumns.date:
        return 'date';
    }
  }
}
