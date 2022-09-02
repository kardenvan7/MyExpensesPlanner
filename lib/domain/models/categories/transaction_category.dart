import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';

class TransactionCategory {
  final String uuid;
  final Color color;
  final String name;

  TransactionCategory({
    required this.uuid,
    required this.color,
    required this.name,
  });

  factory TransactionCategory.empty() {
    return TransactionCategory(
      uuid: '0',
      color: const Color(0xFFB8B8B8),
      name: 'No category',
    );
  }

  factory TransactionCategory.fromMap(Map map) {
    return TransactionCategory(
      uuid: map['uuid'],
      color: map['color'] is Color
          ? map['color']
          : map['color'] is String
              ? HexColor.fromHex(map['color'])
              : null,
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'color': color.toHexString(),
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
