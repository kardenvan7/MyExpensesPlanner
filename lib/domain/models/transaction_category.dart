import 'package:flutter/cupertino.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/domain/core/extensions/color_extensions.dart';

class TransactionCategory {
  final String uuid;
  final Color color;
  final String name;

  TransactionCategory({
    required this.uuid,
    required this.color,
    required this.name,
  });

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      uuid: map[CategoriesTableColumns.uuid.code],
      color: map[CategoriesTableColumns.color.code] is Color
          ? map[CategoriesTableColumns.color.code]
          : map[CategoriesTableColumns.color.code] is String
              ? HexColor.fromHex(map[CategoriesTableColumns.color.code])
              : null,
      name: map[CategoriesTableColumns.name.code],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CategoriesTableColumns.uuid.code: uuid,
      CategoriesTableColumns.name.code: name,
      CategoriesTableColumns.color.code: color,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is TransactionCategory) {
      return uuid == other.uuid;
    }

    throw FormatException(
      'You can not compare TransactionCategory object to objects of other types',
    );
  }

  @override
  int get hashCode => int.parse(uuid);
}
