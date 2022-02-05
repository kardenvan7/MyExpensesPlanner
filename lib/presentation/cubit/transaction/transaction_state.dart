part of './transaction_cubit.dart';

class TransactionState {
  final String uuid;
  final double amount;
  final String title;
  final DateTime date;
  final TransactionCategory? category;

  TransactionState({
    required this.uuid,
    required this.amount,
    required this.title,
    required this.date,
    this.category,
  });

  factory TransactionState.fromTransaction(Transaction _transaction) {
    return TransactionState(
      uuid: _transaction.uuid,
      amount: _transaction.amount,
      title: _transaction.title,
      date: _transaction.date,
      category: _transaction.category,
    );
  }

  TransactionState copyWith({
    String? newTitle,
    double? newAmount,
    DateTime? newDate,
    TransactionCategory? newCategory,
  }) {
    return TransactionState(
      uuid: uuid,
      amount: newAmount ?? amount,
      title: newTitle ?? title,
      date: newDate ?? date,
      category: newCategory ?? category,
    );
  }
}
