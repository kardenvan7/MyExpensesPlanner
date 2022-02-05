import 'package:flutter/cupertino.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart'
    as data;

class TransactionCategory {
  final String uuid;
  final Color color;
  final String name;

  TransactionCategory({
    required this.uuid,
    required this.color,
    required this.name,
  });

  factory TransactionCategory.fromMap(Map map) {
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

  factory TransactionCategory.fromDataTransactionCategory(
    data.TransactionCategory _category,
  ) {
    return TransactionCategory(
      uuid: _category.uuid,
      color: _category.color,
      name: _category.name,
    );
  }

  data.TransactionCategory toDataTransactionCategory() {
    return data.TransactionCategory(
      uuid: uuid,
      color: color,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'color': color,
    };
  }

  TransactionCategory copyWith({
    String? uuid,
    Color? color,
    String? name,
  }) {
    return TransactionCategory(
      uuid: uuid ?? this.uuid,
      color: color ?? this.color,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is TransactionCategory) {
      return uuid == other.uuid;
    }

    return false;
  }

  @override
  int get hashCode => int.parse(uuid);
}