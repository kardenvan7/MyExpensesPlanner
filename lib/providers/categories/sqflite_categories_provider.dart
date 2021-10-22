import 'package:my_expenses_planner/extensions/color_extensions.dart';
import 'package:my_expenses_planner/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/providers/categories/categories_provider.dart';

class SqfliteCategoriesProvider implements ICategoriesProvider {
  final SqfliteDatabaseProvider _dbProvider = SqfliteDatabaseProvider();
  static const String tableName = categoriesTableName;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    final List<Map<String, dynamic>> categoriesMapList =
        await _dbProvider.database.rawQuery(
      'SELECT ${CategoriesTableColumns.uuid.code}, ${CategoriesTableColumns.name.code}, ${CategoriesTableColumns.color.code} FROM $tableName',
    );

    final List<TransactionCategory> categoriesList = [];

    for (final Map<String, dynamic> categoryMap in categoriesMapList) {
      categoriesList.add(
        TransactionCategory.fromMap(categoryMap),
      );
    }

    return categoriesList;
  }

  @override
  Future<void> save(TransactionCategory category) async {
    final int id = await _dbProvider.database.insert(
      tableName,
      _getMapForDb(category),
    );

    if (id == 0) {
      print('Saving category failed');
      throw FormatException('Saving category failed');
    }
  }

  Map<String, Object?> _getMapForDb(TransactionCategory category) {
    final Map<String, Object?> map = category.toMap();
    map[CategoriesTableColumns.color.code] = category.color.toHexString();

    return map;
  }
}
