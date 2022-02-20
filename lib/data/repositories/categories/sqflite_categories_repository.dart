import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/data/local_db/config.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart'
    as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_categories_repository.dart';

class SqfliteCategoriesRepository implements ICategoriesRepository {
  SqfliteCategoriesRepository(this._dbWrapper);

  static const String tableName = SqfliteDbConfig.categoriesTableName;

  final DatabaseWrapper _dbWrapper;

  @override
  Future<List<domain.TransactionCategory>> getCategories() async {
    final List<Map<String, dynamic>> categoriesMapList =
        await _dbWrapper.rawQuery(
      'SELECT *'
      'FROM $tableName',
    );

    final List<domain.TransactionCategory> categoriesList = [];

    for (final Map<String, dynamic> categoryMap in categoriesMapList) {
      categoriesList.add(
        domain.TransactionCategory.fromMap(categoryMap),
      );
    }

    return categoriesList;
  }

  @override
  Future<domain.TransactionCategory?> getCategoryByUuid(String uuid) async {
    final List<Map<String, dynamic>> _categoryMapList =
        await _dbWrapper.rawQuery(
      'SELECT * FROM $tableName '
      'WHERE ${CategoriesTableColumns.uuid.code} = $uuid '
      'LIMIT 1',
    );

    if (_categoryMapList.isEmpty) {
      return null;
    }

    return domain.TransactionCategory.fromMap(_categoryMapList.first);
  }

  @override
  Future<void> save(domain.TransactionCategory category) async {
    final int id = await _dbWrapper.insert(
      tableName,
      _getMapForDb(category),
    );

    if (id == 0) {
      throw const FormatException('Saving category failed');
    }
  }

  @override
  Future<void> update(
      String uuid, domain.TransactionCategory newCategory) async {
    final Map<String, Object?> newCategoryMap = _getMapForDb(newCategory);

    final int rowsChangedCount = await _dbWrapper.update(
      tableName,
      newCategoryMap,
      where: '${CategoriesTableColumns.uuid.code} = $uuid',
    );

    if (rowsChangedCount == 0) {
      throw const FormatException('Updating category failed');
    }
  }

  Map<String, Object?> _getMapForDb(domain.TransactionCategory category) {
    final Map<String, Object?> map = category.toMap();
    map[CategoriesTableColumns.color.code] = category.color.toHexString();

    return map;
  }

  @override
  Future<void> delete(String uuid) async {
    await _dbWrapper.update(
      SqfliteDbConfig.transactionsTableName,
      {TransactionsTableColumns.categoryUuid.code: null},
      where: '${TransactionsTableColumns.categoryUuid.code} = $uuid',
    );

    final int rowsDeletedCount = await _dbWrapper.delete(
      tableName,
      where: '${CategoriesTableColumns.uuid.code} = $uuid',
    );

    if (rowsDeletedCount == 0) {
      throw const FormatException('Deleting category failed');
    }
  }
}
