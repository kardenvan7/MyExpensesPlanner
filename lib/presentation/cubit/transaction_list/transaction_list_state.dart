part of './transaction_list_cubit.dart';

class TransactionListState {
  TransactionListState({
    required this.isLoading,
    required this.transactions,
    required this.transactionsByDates,
    required this.transactionsByCategories,
    required this.sortedDates,
    required this.canLoadMore,
    required this.offset,
    required this.initialized,
    required this.showLoadingIndicator,
    this.triggerBuilder = true,
    this.dateTimeRange,
    this.categoryUuid,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Transaction> transactions;
  final Map<DateTime, List<Transaction>> transactionsByDates;
  final Map<String?, List<Transaction>> transactionsByCategories;
  final List<DateTime> sortedDates;
  final bool canLoadMore;
  final int offset;
  final bool initialized;
  final bool showLoadingIndicator;
  final bool triggerBuilder;
  final DateTimeRange? dateTimeRange;
  final String? categoryUuid;
  final String? errorMessage;

  bool get hasError => errorMessage != null;

  bool get errorWhileInitializing => hasError && !initialized;

  TransactionListState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    List<DateTime>? sortedDates,
    Map<DateTime, List<Transaction>>? transactionsByDates,
    Map<String?, List<Transaction>>? transactionsByCategories,
    bool? canLoadMore,
    int? offset,
    bool? initialized,
    bool? showLoadingIndicator,
    bool? triggerBuilder,
    String? errorMessage,
    ValueWrapper<DateTimeRange>? dateTimeRange,
    ValueWrapper<String>? categoryUuid,
  }) {
    return TransactionListState(
      isLoading: isLoading ?? false,
      transactions: transactions ?? this.transactions,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      sortedDates: sortedDates ?? this.sortedDates,
      transactionsByDates: transactionsByDates ?? this.transactionsByDates,
      transactionsByCategories:
          transactionsByCategories ?? this.transactionsByCategories,
      offset: offset ?? this.offset,
      initialized: initialized ?? this.initialized,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      triggerBuilder: triggerBuilder ?? true,
      errorMessage: errorMessage,
      dateTimeRange:
          dateTimeRange != null ? dateTimeRange.value : this.dateTimeRange,
      categoryUuid:
          categoryUuid != null ? categoryUuid.value : this.categoryUuid,
    );
  }

  Map<String?, double> get amountsByCategory {
    final Map<String?, double> _map = {};

    for (final String? categoryUuid in transactionsByCategories.keys.toList()) {
      final double _amountByCategory =
          transactionsByCategories[categoryUuid]!.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );

      _map[categoryUuid] = _amountByCategory;
    }

    return _map;
  }
}
