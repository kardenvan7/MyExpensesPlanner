part of 'last_week_graphs_cubit.dart';

class LastWeekGraphsState {
  LastWeekGraphsState({
    this.isLoading = false,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  final bool isLoading;
  final List<Transaction> transactions;

  double get max {
    double maxAmount = 0;

    final _dates = transactionsByDate.keys.toList();

    for (final DateTime _date in _dates) {
      final double _amountInDay = transactionsByDate[_date]!.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );

      if (_amountInDay > maxAmount) {
        maxAmount = _amountInDay;
      }
    }

    return maxAmount;
  }

  Map<DateTime, List<Transaction>> get transactionsByDate {
    final Map<DateTime, List<Transaction>> _transactionsByDate = {};

    for (final Transaction _transaction in transactions) {
      final _date = _transaction.date.withoutTime;

      if (_transactionsByDate.containsKey(_date)) {
        _transactionsByDate[_date]!.add(_transaction);
      } else {
        _transactionsByDate[_date] = [_transaction];
      }
    }

    return _transactionsByDate;
  }
}
