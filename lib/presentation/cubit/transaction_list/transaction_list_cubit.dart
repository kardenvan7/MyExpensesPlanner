import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part './transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit({
    required ITransactionsCase transactionsCaseImpl,
    int? loadLimit,
  })  : _transactionsCaseImpl = transactionsCaseImpl,
        super(
          TransactionListState(
            isLazyLoading: true,
            transactions: [],
            loadLimit: loadLimit,
            canLoadMore: true,
            offset: 0,
            initialized: false,
            showLoadingIndicator: true,
          ),
        );

  late final StreamSubscription _subscription;

  final ScrollController scrollController = ScrollController();

  bool get _isScrollNearBottom =>
      scrollController.offset >=
          scrollController.position.maxScrollExtent - 300 &&
      !scrollController.position.outOfRange;

  final ITransactionsCase _transactionsCaseImpl;

  Future<void> initialize({
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
  }) async {
    if (!state.initialized) {
      emit(
        state.copyWith(
          dateTimeRange: ValueWrapper(value: dateTimeRange),
          categoryUuid: ValueWrapper(value: categoryUuid),
        ),
      );

      _subscription = _transactionsCaseImpl.stream.listen(_refreshWithNewData);

      scrollController.addListener(_scrollListener);

      emit(state.copyWith(initialized: true, triggerBuilder: false));

      await fetchTransactions();
    }
  }

  Future<void> refresh() async {
    emit(
      state.copyWith(
        transactions: [],
        offset: 0,
        canLoadMore: true,
        triggerBuilder: false,
      ),
    );

    await fetchTransactions();
  }

  Future<void> fetchTransactions({bool isLazyLoading = false}) async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    emit(
      state.copyWith(
        isLazyLoading: isLazyLoading,
        showLoadingIndicator: state.transactions.isEmpty,
      ),
    );

    final _currentTransactions = [...state.transactions];

    final _result = await _transactionsCaseImpl.getTransactions(
      limit: state.dateTimeRange != null ? null : state.loadLimit,
      offset: state.dateTimeRange != null ? null : state.offset,
      dateTimeRange: state.dateTimeRange,
      categoryUuid: state.categoryUuid,
    );

    _result.fold(
      onFailure: (_) {
        emit(
          state.copyWith(
            isLazyLoading: false,
            errorMessage:
                AppLocalizationsFacade.ofGlobalContext().unknown_error_occurred,
            showLoadingIndicator: false,
          ),
        );
      },
      onSuccess: (_fetchedTransactions) {
        _currentTransactions.addAll(_fetchedTransactions);

        emit(
          state.copyWith(
            isLazyLoading: false,
            showLoadingIndicator: false,
            transactions: _currentTransactions,
            canLoadMore: _fetchedTransactions.length == state.loadLimit,
            offset: state.offset + _fetchedTransactions.length,
            initialized: true,
          ),
        );
      },
    );
  }

  Future<void> addTransaction(
    Transaction transaction,
  ) async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    await _transactionsCaseImpl.save(transaction: transaction);
  }

  Future<void> editTransaction({
    required String txId,
    required Transaction newTransaction,
  }) async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    await _transactionsCaseImpl.edit(
      transactionId: txId,
      newTransaction: newTransaction,
    );
  }

  Future<void> deleteTransaction(String txId) async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    await _transactionsCaseImpl.delete(transactionId: txId);
  }

  void _refreshWithNewData(
    Result<FetchFailure, TransactionsChangeData> dataResult,
  ) {
    dataResult.fold(
      onFailure: (_) {},
      onSuccess: (newData) {
        final List<Transaction> _transactions = _copyCurrentTransactions();
        final DateTimeRange? _pickedDateTimeRange = state.dateTimeRange;

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

          if (_pickedDateTimeRange == null) {
            _transactions.addAll(
              newData.addedTransactions.followedBy(
                newData.editedTransactions,
              ),
            );
          } else {
            _transactions.addAll(
              newData.addedTransactions
                  .where(
                    (element) =>
                        element.date.isAfter(_pickedDateTimeRange.start) &&
                        element.date.isBefore(_pickedDateTimeRange.end),
                  )
                  .followedBy(
                    newData.editedTransactions.where(
                      (element) =>
                          element.date.isAfter(_pickedDateTimeRange.start) &&
                          element.date.isBefore(_pickedDateTimeRange.end),
                    ),
                  ),
            );
          }

          final _uniqueTransactions = _transactions.toSet().toList();

          emit(
            state.copyWith(
              transactions: _uniqueTransactions,
              showLoadingIndicator: false,
              initialized: true,
              isLazyLoading: false,
              triggerBuilder: true,
            ),
          );
        } else {
          emitEmptyState();
        }
      },
    );
  }

  void emitEmptyState({bool triggerBuilder = true}) {
    emit(
      state.copyWith(
        transactions: [],
        offset: 0,
        isLazyLoading: false,
        showLoadingIndicator: false,
        triggerBuilder: triggerBuilder,
      ),
    );
  }

  Future<void> fillWithMockTransactions() async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    emit(state.copyWith(isLazyLoading: true, showLoadingIndicator: true));

    try {
      final List<Transaction> _transactions = [];

      for (int i = 1; i <= 20; i++) {
        await Future.delayed(
          const Duration(milliseconds: 100),
          () {
            _transactions.add(
              Transaction(
                uuid: DateTime.now().microsecondsSinceEpoch.toString(),
                amount: (i * 1.2).toInt().toDouble(),
                title: 'Transaction',
                date: DateTime.now(),
                type: i % 2 == 0
                    ? TransactionType.expense
                    : TransactionType.income,
              ),
            );
          },
        );
      }

      await _transactionsCaseImpl.saveMultiple(transactions: _transactions);

      emit(
        state.copyWith(
          isLazyLoading: false,
          showLoadingIndicator: false,
        ),
      );
    } catch (e, _) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          showLoadingIndicator: false,
        ),
      );
    }
  }

  Future<void> onDateTimeRangeChange(DateTimeRange? range) async {
    emitEmptyState(triggerBuilder: false);

    emit(
      state.copyWith(
        dateTimeRange: ValueWrapper(value: range),
        triggerBuilder: false,
      ),
    );

    fetchTransactions();
  }

  Future<void> deleteAllTransactions() async {
    if (!state.initialized) {
      throw const FormatException('Cubit is not initialized');
    }

    emit(
      state.copyWith(
        isLazyLoading: true,
        showLoadingIndicator: true,
      ),
    );

    try {
      await _transactionsCaseImpl.deleteAll();

      emitEmptyState();
    } catch (e) {
      emit(
        state.copyWith(
          showLoadingIndicator: false,
          errorMessage: e.toString(),
          isLazyLoading: false,
        ),
      );
    }
  }

  Future<void> _scrollListener() async {
    if (_isScrollNearBottom && state.canLoadMore && !state.isLazyLoading) {
      fetchTransactions(isLazyLoading: true);
    }
  }

  List<Transaction> _copyCurrentTransactions() {
    return List.generate(
      state.transactions.length,
      (index) => state.transactions[index].copyWith(),
    );
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    return super.close();
  }
}
