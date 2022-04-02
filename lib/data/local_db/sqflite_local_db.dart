import 'package:my_expenses_planner/data/local_db/config.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabaseProvider {
  factory SqfliteDatabaseProvider() {
    return _instance;
  }

  SqfliteDatabaseProvider._();

  static const String _dbFileName = 'myExpensesPlanner.db';
  static const int _version = 3;

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
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute(
            'ALTER TABLE ${SqfliteDbConfig.transactionsTableName} '
            'ADD COLUMN ${TransactionsTableColumns.type.code} TEXT DEFAULT '
            '"${TransactionType.expense.name}"'
            ';',
          );
        }

        if (oldVersion == 2 && newVersion == 3) {
          await db.execute(
            'CREATE TABLE transactions_replacement ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            '${TransactionsTableColumns.uuid.code} TEXT, '
            '${TransactionsTableColumns.title.code} TEXT, '
            '${TransactionsTableColumns.amount.code} REAL, '
            '${TransactionsTableColumns.date.code} INT, '
            '${TransactionsTableColumns.type.code} TEXT, '
            '${TransactionsTableColumns.categoryUuid.code} TEXT'
            ' REFERENCES ${SqfliteDbConfig.categoriesTableName}'
            '(${CategoriesTableColumns.uuid.code})'
            ');',
          );

          await db.execute(
            'INSERT INTO transactions_replacement('
            '${TransactionsTableColumns.uuid.code},'
            '${TransactionsTableColumns.title.code},'
            '${TransactionsTableColumns.amount.code},'
            '${TransactionsTableColumns.date.code},'
            '${TransactionsTableColumns.type.code}, '
            '${TransactionsTableColumns.categoryUuid.code}'
            ')'
            ' SELECT '
            '${TransactionsTableColumns.uuid.code},'
            '${TransactionsTableColumns.title.code},'
            '${TransactionsTableColumns.amount.code},'
            '${TransactionsTableColumns.date.code},'
            '${TransactionsTableColumns.type.code}, '
            '${TransactionsTableColumns.categoryUuid.code}'
            ' FROM transactions;',
          );

          await db.execute(
            'DROP TABLE IF EXISTS ${SqfliteDbConfig.transactionsTableName};',
          );

          await db.execute(
            'CREATE TABLE ${SqfliteDbConfig.transactionsTableName} ('
            '${TransactionsTableColumns.uuid.code} TEXT PRIMARY KEY, '
            '${TransactionsTableColumns.title.code} TEXT, '
            '${TransactionsTableColumns.amount.code} REAL, '
            '${TransactionsTableColumns.date.code} INT, '
            '${TransactionsTableColumns.type.code} TEXT, '
            '${TransactionsTableColumns.categoryUuid.code} TEXT'
            ' REFERENCES ${SqfliteDbConfig.categoriesTableName}'
            '(${CategoriesTableColumns.uuid.code})'
            ');',
          );

          await db.execute(
            'INSERT INTO ${SqfliteDbConfig.transactionsTableName}('
            '${TransactionsTableColumns.uuid.code},'
            '${TransactionsTableColumns.title.code},'
            '${TransactionsTableColumns.amount.code},'
            '${TransactionsTableColumns.date.code},'
            '${TransactionsTableColumns.type.code}, '
            '${TransactionsTableColumns.categoryUuid.code}'
            ')'
            ' SELECT '
            '${TransactionsTableColumns.uuid.code},'
            '${TransactionsTableColumns.title.code},'
            '${TransactionsTableColumns.amount.code},'
            '${TransactionsTableColumns.date.code},'
            '${TransactionsTableColumns.type.code}, '
            '${TransactionsTableColumns.categoryUuid.code}'
            ' FROM transactions_replacement;',
          );

          await db.execute(
            'DROP TABLE IF EXISTS transactions_replacement;',
          );
        }
      },
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE ${SqfliteDbConfig.categoriesTableName} ('
          '${CategoriesTableColumns.uuid.code} TEXT PRIMARY KEY, '
          '${CategoriesTableColumns.name.code} TEXT, '
          '${CategoriesTableColumns.color.code} TEXT'
          ')',
        );

        await db.execute(
          'CREATE TABLE ${SqfliteDbConfig.transactionsTableName} ('
          '${TransactionsTableColumns.uuid.code} TEXT PRIMARY KEY, '
          '${TransactionsTableColumns.title.code} TEXT, '
          '${TransactionsTableColumns.amount.code} REAL, '
          '${TransactionsTableColumns.date.code} INT, '
          '${TransactionsTableColumns.type.code} TEXT, '
          '${TransactionsTableColumns.categoryUuid.code} TEXT REFERENCES '
          '${SqfliteDbConfig.categoriesTableName}(${CategoriesTableColumns.uuid.code})'
          ');',
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

enum TransactionsTableColumns { uuid, title, amount, date, categoryUuid, type }
enum TransactionType { expense, income }
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
      case TransactionsTableColumns.type:
        return 'type';
    }
  }
}
