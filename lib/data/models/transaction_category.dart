import 'package:flutter/cupertino.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart'
    as domain;

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
      uuid: map['uuid'],
      name: map['name'],
      color: map['color'] is Color
          ? map['color']
          : map['color'] is String
              ? HexColor.fromHex(map['color'])
              : null,
    );
  }

  factory TransactionCategory.fromDomainCategory(
    domain.TransactionCategory category,
  ) {
    return TransactionCategory(
      uuid: category.uuid,
      color: category.color,
      name: category.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'color': color,
    };
  }

  domain.TransactionCategory toDomainCategory() {
    return domain.TransactionCategory(
      uuid: uuid,
      name: name,
      color: color,
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
