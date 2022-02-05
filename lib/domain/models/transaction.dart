import 'package:my_expenses_planner/data/models/transaction.dart' as data;

import './transaction_category.dart';

class Transaction {
  Transaction({
    required this.uuid,
    required this.amount,
    required this.title,
    required this.date,
    this.category,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      uuid: map['uuid'] as String,
      amount: map['amount'] as double,
      title: map['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
        map['date'] as int,
      ),
      category: map['category_list'] is Map
          ? TransactionCategory.fromMap(map['category_list'] as Map)
          : null,
    );
  }

  factory Transaction.fromDataTransaction(data.Transaction _transaction) {
    return Transaction(
      uuid: _transaction.uuid,
      amount: _transaction.amount,
      title: _transaction.title,
      date: _transaction.date,
      category: _transaction.category != null
          ? TransactionCategory.fromDataTransactionCategory(
              _transaction.category!,
            )
          : null,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final TransactionCategory? category;

  data.Transaction toDataTransaction() {
    return data.Transaction(
      uuid: uuid,
      amount: amount,
      title: title,
      date: date,
      category: category?.toDataTransactionCategory(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'code': amount,
      'date': date.millisecondsSinceEpoch,
      'category_list': category?.toMap(),
    };
  }

  Transaction copyWith({
    String? uuid,
    String? title,
    double? amount,
    DateTime? date,
    TransactionCategory? category,
  }) {
    return Transaction(
      uuid: uuid ?? this.uuid,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
