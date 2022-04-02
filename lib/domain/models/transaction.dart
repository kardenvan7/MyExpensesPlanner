import 'package:my_expenses_planner/core/utils/value_wrapper.dart';

class Transaction {
  Transaction({
    required this.uuid,
    required this.amount,
    required this.title,
    required this.date,
    required this.type,
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
      type: TransactionTypeFactory.fromCode(map['type'] as String?),
      categoryUuid: map['category_uuid'] as String?,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final TransactionType type;
  final String? categoryUuid;

  bool get isIncome => type == TransactionType.income;

  Map<String, Object?> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'type': type.name,
      'category_uuid': isIncome ? null : categoryUuid,
    };
  }

  Transaction copyWith({
    String? uuid,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    ValueWrapper<String>? categoryUuid,
  }) {
    return Transaction(
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      categoryUuid:
          categoryUuid == null ? this.categoryUuid : categoryUuid.value,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is Transaction) {
      return uuid == other.uuid;
    }

    return false;
  }

  @override
  int get hashCode => uuid.hashCode;
}

enum TransactionType { expense, income }

extension TransactionTypeFactory on TransactionType {
  static TransactionType fromCode(String? code) {
    if (code == TransactionType.income.name) {
      return TransactionType.income;
    } else {
      return TransactionType.expense;
    }
  }
}
