import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/data/models/transaction.dart' as data;

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

  factory Transaction.fromDataTransaction(data.Transaction _transaction) {
    return Transaction(
      uuid: _transaction.uuid,
      amount: _transaction.amount,
      title: _transaction.title,
      date: _transaction.date,
      categoryUuid: _transaction.categoryUuid,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final String? categoryUuid;

  data.Transaction toDataTransaction() {
    return data.Transaction(
      uuid: uuid,
      amount: amount,
      title: title,
      date: date,
      categoryUuid: categoryUuid,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'code': amount,
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
