part of './transaction_list_cubit.dart';

class TransactionListState {
  final bool isLoading;
  final List<Transaction> transactions;

  TransactionListState({
    required this.isLoading,
    required this.transactions,
  });

  TransactionListState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
  }) {
    return TransactionListState(
      isLoading: isLoading ?? false,
      transactions: transactions ?? this.transactions,
    );
  }

  List<Transaction> _copyCurrentTransactions() {
    return [...transactions];
  }

  List<Transaction> get sortedByDateTransactions {
    final List<Transaction> sortedTransactions = _copyCurrentTransactions();

    sortedTransactions.sort(
      (current, next) => next.date.compareTo(
        current.date,
      ),
    );

    return sortedTransactions;
  }

  List<Transaction> get lastWeekTransactions {
    final DateTime now = DateTime.now();
    final DateTime weekBefore = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    return transactions.where((element) {
      return element.date > weekBefore;
    }).toList();
  }

  double get fullAmount => transactions.fold(
        0,
        (previousValue, element) => element.amount + previousValue,
      );
}
