import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part 'last_week_graphs_state.dart';

class LastWeekGraphsCubit extends Cubit<LastWeekGraphsState> {
  LastWeekGraphsCubit(
    this._transactionsCase,
  ) : super(LastWeekGraphsState());

  final ITransactionsCase _transactionsCase;

  Future<void> fetchLastWeekTransactions() async {
    emit(
      LastWeekGraphsState(isLoading: true),
    );

    final List<Transaction> _transactions =
        await _transactionsCase.getLastWeekTransactions();

    _transactions.sort(
      (current, next) => next.date.compareTo(current.date),
    );

    emit(
      LastWeekGraphsState(
        transactions: _transactions,
      ),
    );
  }
}
