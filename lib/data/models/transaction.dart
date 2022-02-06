import 'package:my_expenses_planner/data/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';

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
      uuid: map[TransactionsTableColumns.uuid.code] as String,
      amount: map[TransactionsTableColumns.amount.code] as double,
      title: map[TransactionsTableColumns.title.code] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[TransactionsTableColumns.date.code] as int,
      ),
      category: map['category'] is Map
          ? TransactionCategory.fromMap(map['category'] as Map)
          : null,
    );
  }

  final String uuid;
  final DateTime date;
  final String title;
  final double amount;
  final TransactionCategory? category;

  Transaction copyWith({
    required String uuid,
    String? newTitle,
    double? newAmount,
    DateTime? newDate,
    TransactionCategory? newCategory,
  }) {
    return Transaction(
      uuid: uuid,
      amount: newAmount ?? amount,
      title: newTitle ?? title,
      date: newDate ?? date,
      category: newCategory ?? category,
    );
  }

  Map<String, Object?> toMap() {
    return {
      TransactionsTableColumns.uuid.code: uuid,
      TransactionsTableColumns.title.code: title,
      TransactionsTableColumns.amount.code: amount,
      TransactionsTableColumns.date.code: date.millisecondsSinceEpoch,
      'category': category?.toMap(),
    };
  }
}
