part of 'last_week_graphs_cubit.dart';

class LastWeekGraphsState {
  LastWeekGraphsState({
    this.isLoading = false,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  final bool isLoading;
  final List<Transaction> transactions;

  double get max {
    double max = 0;

    for (final Transaction transaction in transactions) {
      if (max < transaction.amount) {
        max = transaction.amount;
      }
    }

    return max;
  }
}
