import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/extensions/datetime_extensions.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/providers/transactions/transactions_provider.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({required this.transactionsProvider})
      : super(
          TransactionsState(
            type: TransactionsStateType.initial,
            transactions: [],
          ),
        );

  final ITransactionsProvider transactionsProvider;
  late List<Transaction> transactions;

  double get fullAmount => transactions.fold(
      0, (previousValue, element) => element.amount + previousValue);

  Future<void> fetchLastTransactions() async {
    transactions = await transactionsProvider.getLastTransactions();

    emit(
      TransactionsState(
        type: TransactionsStateType.loaded,
        transactions: transactions,
      ),
    );
  }

  List<Transaction> get lastWeekTransactions {
    final DateTime now = DateTime.now();
    final DateTime weekBefore = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 7));

    return transactions.where((element) {
      return element.date > weekBefore;
    }).toList();
  }
}

class TransactionsState {
  final List<Transaction> transactions;
  final TransactionsStateType type;

  TransactionsState({required this.type, required this.transactions});
}

enum TransactionsStateType { initial, loaded }
