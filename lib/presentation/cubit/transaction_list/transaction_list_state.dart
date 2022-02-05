part of './transaction_list_cubit.dart';

class TransactionListState {
  final TransactionsStateType type;
  final List<Transaction> transactions;

  TransactionListState({
    required this.type,
    required this.transactions,
  });

  TransactionListState copyWith({
    TransactionsStateType? type,
    List<Transaction>? transactions,
  }) {
    return TransactionListState(
      type: type ?? this.type,
      transactions: transactions ?? this.transactions,
    );
  }
}

enum TransactionsStateType { initial, loaded }
