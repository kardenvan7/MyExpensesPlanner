import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;

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
      type: TransactionTypeFactory.fromName(
        map['type'] as String?,
      ),
      categoryUuid: map['category_uuid'] as String?,
    );
  }

  factory Transaction.fromDomainTransaction(domain.Transaction _transaction) {
    return Transaction(
      uuid: _transaction.uuid,
      amount: _transaction.amount,
      title: _transaction.title,
      date: _transaction.date,
      type: TransactionTypeFactory.fromName(_transaction.type.name),
      categoryUuid: _transaction.categoryUuid,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final TransactionType type;
  final String? categoryUuid;

  Transaction copyWith({
    required String uuid,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    ValueWrapper<String>? categoryUuid,
  }) {
    return Transaction(
      uuid: uuid,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      categoryUuid:
          categoryUuid == null ? this.categoryUuid : categoryUuid.value,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'type': type.name,
      'category_uuid': categoryUuid,
    };
  }

  domain.Transaction toDomainTransaction() {
    return domain.Transaction(
      uuid: uuid,
      amount: amount,
      title: title,
      date: date,
      type: domain.TransactionTypeFactory.fromCode(type.name),
      categoryUuid: categoryUuid,
    );
  }
}

enum TransactionType { expense, income }

extension TransactionTypeFactory on TransactionType {
  static TransactionType fromName(String? code) {
    if (code == TransactionType.income.name) {
      return TransactionType.income;
    } else {
      return TransactionType.expense;
    }
  }
}
