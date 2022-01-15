import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabaseProvider {
  factory SqfliteDatabaseProvider() {
    return _instance;
  }

  SqfliteDatabaseProvider._();

  static const String _dbFileName = 'myExpensesPlanner.db';
  static const int _version = 1;

  static final SqfliteDatabaseProvider _instance = SqfliteDatabaseProvider._();

  late final Database database;
  late final String _myDbPath;

  Future<void> initDatabase() async {
    final String _databasesPath = await getDatabasesPath();
    _myDbPath = join(_databasesPath, _dbFileName);

    database = await openDatabase(
      _myDbPath,
      version: _version,
      onOpen: (Database db) async {
        db.execute('PRAGMA foreign_keys=ON');
      },
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $transactionsTableName ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${TransactionsTableColumns.uuid.code} TEXT, '
          '${TransactionsTableColumns.title.code} TEXT, '
          '${TransactionsTableColumns.amount.code} REAL, '
          '${TransactionsTableColumns.date.code} INT'
          ');',
        );

        await db.execute(
          'ALTER TABLE $transactionsTableName ADD COLUMN ${TransactionsTableColumns.categoryUuid.code} TEXT REFERENCES $categoriesTableName(${CategoriesTableColumns.uuid.code})',
        );

        await db.execute(
          'CREATE TABLE $categoriesTableName ('
          '${CategoriesTableColumns.uuid.code} TEXT PRIMARY KEY, '
          '${CategoriesTableColumns.name.code} TEXT, '
          '${CategoriesTableColumns.color.code} TEXT'
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

const String transactionsTableName = 'transactions';
const String categoriesTableName = 'categories';

enum TransactionsTableColumns { uuid, title, amount, date, categoryUuid }
enum CategoriesTableColumns { uuid, name, color }

extension TransactionCategoriesTableColumnsCodes on CategoriesTableColumns {
  String get code {
    switch (this) {
      case CategoriesTableColumns.uuid:
        return 'uuid';
      case CategoriesTableColumns.name:
        return 'name';
      case CategoriesTableColumns.color:
        return 'color';
    }
  }
}

extension TransactionsTableColumnsCodes on TransactionsTableColumns {
  String get code {
    switch (this) {
      case TransactionsTableColumns.uuid:
        return 'uuid';
      case TransactionsTableColumns.title:
        return 'title';
      case TransactionsTableColumns.amount:
        return 'amount';
      case TransactionsTableColumns.date:
        return 'date';
      case TransactionsTableColumns.categoryUuid:
        return 'category_uuid';
    }
  }
}
