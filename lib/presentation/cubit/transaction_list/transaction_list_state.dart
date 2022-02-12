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

  List<Transaction> get sortedByCreateDateTransactions {
    final _list = [...transactions];

    _list.sort(
      (curElem, newElem) => int.parse(newElem.uuid).compareTo(
        int.parse(curElem.uuid),
      ),
    );

    return _list;
  }

  Map<DateTime, List<Transaction>> get transactionsByDate {
    final Map<DateTime, List<Transaction>> _transactionsByDate = {};

    for (final Transaction _transaction in sortedByCreateDateTransactions) {
      final DateTime _date = DateTime(
        _transaction.date.year,
        _transaction.date.month,
        _transaction.date.day,
      );

      if (_transactionsByDate.containsKey(_date)) {
        _transactionsByDate[_date]!.add(_transaction);
      } else {
        _transactionsByDate[_date] = [_transaction];
      }
    }

    return _transactionsByDate;
  }

  List<DateTime> get sortedDates {
    return transactionsByDate.keys.toList()
      ..sort(
        (curDateTime, newDateTime) => newDateTime.compareTo(
          curDateTime,
        ),
      );
  }
}
