import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';

class Transaction extends Cubit<TransactionState> {
  final String uuid;
  DateTime date;
  String title;
  double amount;
  TransactionCategory? category;

  Transaction({
    required this.uuid,
    required this.amount,
    required this.title,
    required this.date,
    this.category,
  }) : super(TransactionState());

  Transaction copyWith({
    String? newTitle,
    double? newAmount,
    DateTime? newDate,
    TransactionCategory? newCategory,
  }) {
    return Transaction(
      uuid: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: newAmount ?? amount,
      title: newTitle ?? title,
      date: newDate ?? date,
      category: newCategory ?? category,
    );
  }

  void edit({
    String? newTitle,
    double? newAmount,
    DateTime? newDateTime,
    TransactionCategory? newCategory,
  }) {
    amount = newAmount ?? amount;
    title = newTitle ?? title;
    date = newDateTime ?? date;
    category = newCategory ?? category;

    emit(TransactionState());
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

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      uuid: map[TransactionsTableColumns.uuid.code] as String,
      amount: map[TransactionsTableColumns.amount.code] as double,
      title: map[TransactionsTableColumns.title.code] as String,
      date: DateTime.fromMillisecondsSinceEpoch(
        map[TransactionsTableColumns.date.code] as int,
      ),
      category: map.containsKey('category') && map['category'] != null
          ? TransactionCategory.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TransactionState {}
