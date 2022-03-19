part of './transaction_list_cubit.dart';

class TransactionListState {
  TransactionListState({
    required this.isLoading,
    required this.transactions,
    required this.canLoadMore,
    required this.offset,
    required this.initialized,
    required this.showLoadingIndicator,
    this.triggerBuilder = true,
    this.dateTimeRange,
    this.loadLimit,
    this.categoryUuid,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Transaction> transactions;
  final bool canLoadMore;
  final int offset;
  final bool initialized;
  final bool showLoadingIndicator;
  final bool triggerBuilder;
  final DateTimeRange? dateTimeRange;
  final int? loadLimit;
  final String? categoryUuid;
  final String? errorMessage;

  bool get hasError => errorMessage != null;

  bool get errorWhileInitializing => hasError && !initialized;

  TransactionListState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    bool? canLoadMore,
    int? offset,
    bool? initialized,
    bool? showLoadingIndicator,
    bool? triggerBuilder,
    int? loadLimit,
    String? errorMessage,
    ValueWrapper<DateTimeRange>? dateTimeRange,
    ValueWrapper<String>? categoryUuid,
  }) {
    return TransactionListState(
      isLoading: isLoading ?? false,
      transactions: transactions ?? this.transactions,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      offset: offset ?? this.offset,
      initialized: initialized ?? this.initialized,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      triggerBuilder: triggerBuilder ?? true,
      errorMessage: errorMessage,
      loadLimit: loadLimit ?? this.loadLimit,
      dateTimeRange:
          dateTimeRange != null ? dateTimeRange.value : this.dateTimeRange,
      categoryUuid:
          categoryUuid != null ? categoryUuid.value : this.categoryUuid,
    );
  }
}
