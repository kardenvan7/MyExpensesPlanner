import 'package:my_expenses_planner/core/utils/value_wrapper.dart';

import './transaction_category.dart';

class Transaction {
  Transaction({
    required this.uuid,
    required this.amount,
    required this.title,
    required this.date,
    this.categoryUuid,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      uuid: map['uuid'] as String,
      amount: map['amount'] as double,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
        map['date'] as int,
      ),
      categoryUuid: map['category_uuid'] as String?,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final String? categoryUuid;

  Map<String, Object?> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'category_uuid': categoryUuid,
    };
  }

  Transaction copyWith({
    String? uuid,
    String? title,
    double? amount,
    DateTime? date,
    TransactionCategory? category,
    ValueWrapper<String>? categoryUuid,
  }) {
    return Transaction(
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      categoryUuid:
          categoryUuid == null ? this.categoryUuid : categoryUuid.value,
    );
  }
}
