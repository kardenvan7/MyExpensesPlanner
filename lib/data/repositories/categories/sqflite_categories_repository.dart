import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/data/local_db/config.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';

class SqfliteCategoriesRepository implements ICategoriesRepository {
  SqfliteCategoriesRepository(this._dbProvider);

  static const String tableName = SqfliteDbConfig.categoriesTableName;

  final SqfliteDatabaseProvider _dbProvider;

  @override
  Future<List<TransactionCategory>> getCategories() async {
    final List<Map<String, dynamic>> categoriesMapList =
        await _dbProvider.database.rawQuery(
      'SELECT *'
      // '${CategoriesTableColumns.uuid.code}, '
      // '${CategoriesTableColumns.name.code}, '
      // '${CategoriesTableColumns.color.code} '
      'FROM $tableName',
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
      throw const FormatException('Saving category_list failed');
    }
  }

  @override
  Future<void> update(String uuid, TransactionCategory newCategory) async {
    final Map<String, Object?> newCategoryMap = _getMapForDb(newCategory);

    final int rowsChangedCount = await _dbProvider.database.update(
      tableName,
      newCategoryMap,
      where: '${CategoriesTableColumns.uuid.code} = $uuid',
    );

    if (rowsChangedCount == 0) {
      throw const FormatException('Updating category_list failed');
    }
  }

  Map<String, Object?> _getMapForDb(TransactionCategory category) {
    final Map<String, Object?> map = category.toMap();
    map[CategoriesTableColumns.color.code] = category.color.toHexString();

    return map;
  }

  @override
  Future<void> delete(String uuid) async {
    await _dbProvider.database.update(
      SqfliteDbConfig.transactionsTableName,
      {TransactionsTableColumns.categoryUuid.code: null},
      where: '${TransactionsTableColumns.categoryUuid.code} = $uuid',
    );

    final int rowsDeletedCount = await _dbProvider.database.delete(
      tableName,
      where: '${CategoriesTableColumns.uuid.code} = $uuid',
    );

    if (rowsDeletedCount == 0) {
      throw const FormatException('Deleting category_list failed');
    }
  }
}
