import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/extensions/datetime_extensions.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/providers/transactions/transactions_provider.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({required this.transactionsProvider})
      : super(
          TransactionsState(
            type: TransactionsStateType.initial,
          ),
        );

  final ITransactionsProvider transactionsProvider;
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  List<Transaction> get sortedByDateTransactions {
    final List<Transaction> sortedTransactions = transactions;

    sortedTransactions
        .sort((current, next) => current.date.compareTo(next.date));

    return sortedTransactions.reversed.toList();
  }

  double get fullAmount => _transactions.fold(
      0, (previousValue, element) => element.amount + previousValue);

  Future<void> fetchLastTransactions() async {
    _transactions.addAll(await transactionsProvider.getLastTransactions());

    emit(
      TransactionsState(
        type: TransactionsStateType.loaded,
      ),
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    await Future.microtask(() => _transactions.add(transaction));

    emit(
      TransactionsState(
        type: TransactionsStateType.loaded,
      ),
    );
  }

  Future<void> deleteTransaction(String id) async {
    await Future.microtask(
        () => _transactions.removeWhere((transaction) => transaction.id == id));

    emit(
      TransactionsState(
        type: TransactionsStateType.loaded,
      ),
    );
  }

  List<Transaction> get lastWeekTransactions {
    final DateTime now = DateTime.now();
    final DateTime weekBefore = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    return _transactions.where((element) {
      return element.date > weekBefore;
    }).toList();
  }
}

class TransactionsState {
  final TransactionsStateType type;

  TransactionsState({required this.type});
}

enum TransactionsStateType { initial, loaded }
