part of './transaction_list_cubit.dart';

class TransactionListState {
  TransactionListState({
    required this.isLoading,
    required this.transactions,
    required this.transactionsByDates,
    required this.sortedDates,
    required this.canLoadMore,
    required this.offset,
    required this.initialized,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Transaction> transactions;
  final Map<DateTime, List<Transaction>> transactionsByDates;
  final List<DateTime> sortedDates;
  final bool canLoadMore;
  final int offset;
  final bool initialized;
  final String? errorMessage;

  bool get hasError => errorMessage != null;

  bool get errorWhileInitializing => hasError && !initialized;

  TransactionListState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    List<DateTime>? sortedDates,
    Map<DateTime, List<Transaction>>? transactionsByDates,
    bool? canLoadMore,
    int? offset,
    bool? initialized,
    String? errorMessage,
  }) {
    return TransactionListState(
      isLoading: isLoading ?? false,
      transactions: transactions ?? this.transactions,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      sortedDates: sortedDates ?? this.sortedDates,
      transactionsByDates: transactionsByDates ?? this.transactionsByDates,
      offset: offset ?? this.offset,
      initialized: initialized ?? this.initialized,
      errorMessage: errorMessage,
    );
  }
}
