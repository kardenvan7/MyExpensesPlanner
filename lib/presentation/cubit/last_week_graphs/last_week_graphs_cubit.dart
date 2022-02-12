import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/datetime_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part 'last_week_graphs_state.dart';

class LastWeekGraphsCubit extends Cubit<LastWeekGraphsState> {
  LastWeekGraphsCubit(
    this._transactionsCase,
  ) : super(LastWeekGraphsState());

  final ITransactionsCase _transactionsCase;
  late final StreamSubscription _subscription;
  bool initialized = false;

  Future<void> initialize() async {
    if (!initialized) {
      _subscription = _transactionsCase.stream.listen((newData) {
        _refreshWithNewData(newData);
      });

      fetchLastWeekTransactions();

      initialized = true;
    }
  }

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

  List<Transaction> _copyCurrentTransactions() {
    return List.generate(
      state.transactions.length,
      (index) => state.transactions[index].copyWith(
        uuid: state.transactions[index].uuid,
      ),
    );
  }

  void _refreshWithNewData(TransactionsChangeData newData) {
    final List<Transaction> _transactions = _copyCurrentTransactions();

    _transactions.removeWhere(
      (currentListElement) =>
          newData.deletedTransactionsUuids.contains(currentListElement.uuid) ||
          newData.editedTransactions.firstWhereOrNull(
                (element) => element.uuid == currentListElement.uuid,
              ) !=
              null,
    );

    _transactions.addAll(
      newData.addedTransactions.followedBy(
        newData.editedTransactions,
      ),
    );

    emit(LastWeekGraphsState(transactions: _transactions));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
