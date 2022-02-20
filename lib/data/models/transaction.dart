import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;

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
      uuid: map[TransactionsTableColumns.uuid.code] as String,
      amount: map[TransactionsTableColumns.amount.code] as double,
      title: map[TransactionsTableColumns.title.code] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[TransactionsTableColumns.date.code] as int,
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
      categoryUuid: _transaction.categoryUuid,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final String? categoryUuid;

  Transaction copyWith({
    required String uuid,
    String? title,
    double? amount,
    DateTime? date,
    ValueWrapper<String>? categoryUuid,
  }) {
    return Transaction(
      uuid: uuid,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      categoryUuid:
          categoryUuid == null ? this.categoryUuid : categoryUuid.value,
    );
  }

  Map<String, Object?> toMap() {
    return {
      TransactionsTableColumns.uuid.code: uuid,
      TransactionsTableColumns.title.code: title,
      TransactionsTableColumns.amount.code: amount,
      TransactionsTableColumns.date.code: date.millisecondsSinceEpoch,
      TransactionsTableColumns.categoryUuid.code: categoryUuid,
    };
  }

  domain.Transaction toDataTransaction() {
    return domain.Transaction(
      uuid: uuid,
      amount: amount,
      title: title,
      date: date,
      categoryUuid: categoryUuid,
    );
  }
}
