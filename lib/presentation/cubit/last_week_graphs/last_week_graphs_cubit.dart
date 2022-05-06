import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';
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

      fetchLastWeekExpenses();

      initialized = true;
    }
  }

  Future<void> fetchLastWeekExpenses() async {
    emit(
      LastWeekGraphsState(isLoading: true),
    );

    final _fetchResult = await _transactionsCase.getLastWeekExpenses();

    _fetchResult.fold(
      onFailure: (failure) => emit(
        LastWeekGraphsState(
          errorMessage:
              AppLocalizationsFacade.ofGlobalContext().unknown_error_occurred,
        ),
      ),
      onSuccess: (transactions) {
        final _transactions = [...transactions];

        _transactions.sort(
          (current, next) => next.date.compareTo(current.date),
        );

        emit(
          LastWeekGraphsState(
            transactions: _transactions,
          ),
        );
      },
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

  void _refreshWithNewData(
    Result<FetchFailure, TransactionsChangeData> dataChangeResult,
  ) {
    dataChangeResult.fold(
      onFailure: (failure) {},
      onSuccess: (newData) {
        final List<Transaction> _transactions = _copyCurrentTransactions();

        if (!newData.deletedAll) {
          _transactions.removeWhere(
            (currentListElement) =>
                newData.deletedTransactionsUuids
                    .contains(currentListElement.uuid) ||
                newData.editedTransactions.firstWhereOrNull(
                      (element) => element.uuid == currentListElement.uuid,
                    ) !=
                    null,
          );

          final _now = DateTime.now();
          final _weekAgo = DateTime(
            _now.year,
            _now.month,
            _now.day,
          ).subtract(const Duration(days: 6));

          _transactions.addAll(
            newData.addedTransactions
                .where(
                  (element) =>
                      element.date >= _weekAgo &&
                      element.type == TransactionType.expense,
                )
                .followedBy(
                  newData.editedTransactions.where(
                    (element) =>
                        element.date >= _weekAgo &&
                        element.type == TransactionType.expense,
                  ),
                ),
          );

          final _uniqueTransactions = _transactions.toSet().toList();

          emit(LastWeekGraphsState(transactions: _uniqueTransactions));
        } else {
          emit(LastWeekGraphsState(transactions: []));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
