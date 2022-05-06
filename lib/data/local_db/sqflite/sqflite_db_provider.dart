import 'package:my_expenses_planner/data/local_db/sqflite/sqflite_config.dart';
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
          await _version1To2Migration(db);
        }

        if (oldVersion == 2 && newVersion == 3) {
          await _version2To3Migration(db);
        }
      },
      onCreate: (Database db, int version) async {
        _onCreate(db);
      },
    );
  }

  Future<void> _onCreate(Database db) async {
    await db.execute(
      'CREATE TABLE ${SqfliteDbConfig.categoriesTableName} ('
      '${SqfliteCategoriesTableColumns.uuid.code} TEXT PRIMARY KEY, '
      '${SqfliteCategoriesTableColumns.name.code} TEXT, '
      '${SqfliteCategoriesTableColumns.color.code} TEXT'
      ')',
    );

    await db.execute(
      'CREATE TABLE ${SqfliteDbConfig.transactionsTableName} ('
      '${SqfliteTransactionsTableColumns.uuid.code} TEXT PRIMARY KEY, '
      '${SqfliteTransactionsTableColumns.title.code} TEXT, '
      '${SqfliteTransactionsTableColumns.amount.code} REAL, '
      '${SqfliteTransactionsTableColumns.date.code} INT, '
      '${SqfliteTransactionsTableColumns.type.code} TEXT, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code} TEXT'
      ' REFERENCES ${SqfliteDbConfig.categoriesTableName}'
      '(${SqfliteCategoriesTableColumns.uuid.code})'
      ');',
    );
  }

  Future<void> _version1To2Migration(Database db) async {
    await db.execute(
      'ALTER TABLE ${SqfliteDbConfig.transactionsTableName} '
      'ADD COLUMN ${SqfliteTransactionsTableColumns.type.code} TEXT DEFAULT '
      '"${SqfliteTransactionType.expense.name}"'
      ';',
    );
  }

  Future<void> _version2To3Migration(Database db) async {
    await db.execute(
      'CREATE TABLE transactions_replacement ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '${SqfliteTransactionsTableColumns.uuid.code} TEXT, '
      '${SqfliteTransactionsTableColumns.title.code} TEXT, '
      '${SqfliteTransactionsTableColumns.amount.code} REAL, '
      '${SqfliteTransactionsTableColumns.date.code} INT, '
      '${SqfliteTransactionsTableColumns.type.code} TEXT, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code} TEXT'
      ' REFERENCES ${SqfliteDbConfig.categoriesTableName}'
      '(${SqfliteCategoriesTableColumns.uuid.code})'
      ');',
    );

    await db.execute(
      'INSERT INTO transactions_replacement('
      '${SqfliteTransactionsTableColumns.uuid.code},'
      '${SqfliteTransactionsTableColumns.title.code},'
      '${SqfliteTransactionsTableColumns.amount.code},'
      '${SqfliteTransactionsTableColumns.date.code},'
      '${SqfliteTransactionsTableColumns.type.code}, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code}'
      ')'
      ' SELECT '
      '${SqfliteTransactionsTableColumns.uuid.code},'
      '${SqfliteTransactionsTableColumns.title.code},'
      '${SqfliteTransactionsTableColumns.amount.code},'
      '${SqfliteTransactionsTableColumns.date.code},'
      '${SqfliteTransactionsTableColumns.type.code}, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code}'
      ' FROM transactions;',
    );

    await db.execute(
      'DROP TABLE IF EXISTS ${SqfliteDbConfig.transactionsTableName};',
    );

    await db.execute(
      'CREATE TABLE ${SqfliteDbConfig.transactionsTableName} ('
      '${SqfliteTransactionsTableColumns.uuid.code} TEXT PRIMARY KEY, '
      '${SqfliteTransactionsTableColumns.title.code} TEXT, '
      '${SqfliteTransactionsTableColumns.amount.code} REAL, '
      '${SqfliteTransactionsTableColumns.date.code} INT, '
      '${SqfliteTransactionsTableColumns.type.code} TEXT, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code} TEXT'
      ' REFERENCES ${SqfliteDbConfig.categoriesTableName}'
      '(${SqfliteCategoriesTableColumns.uuid.code})'
      ');',
    );

    await db.execute(
      'INSERT INTO ${SqfliteDbConfig.transactionsTableName}('
      '${SqfliteTransactionsTableColumns.uuid.code},'
      '${SqfliteTransactionsTableColumns.title.code},'
      '${SqfliteTransactionsTableColumns.amount.code},'
      '${SqfliteTransactionsTableColumns.date.code},'
      '${SqfliteTransactionsTableColumns.type.code}, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code}'
      ')'
      ' SELECT '
      '${SqfliteTransactionsTableColumns.uuid.code},'
      '${SqfliteTransactionsTableColumns.title.code},'
      '${SqfliteTransactionsTableColumns.amount.code},'
      '${SqfliteTransactionsTableColumns.date.code},'
      '${SqfliteTransactionsTableColumns.type.code}, '
      '${SqfliteTransactionsTableColumns.categoryUuid.code}'
      ' FROM transactions_replacement;',
    );

    await db.execute(
      'DROP TABLE IF EXISTS transactions_replacement;',
    );
  }

  Future<void> delete() async {
    await deleteDatabase(_myDbPath);
  }

  Future<void> close() async {
    await database.close();
  }
}
