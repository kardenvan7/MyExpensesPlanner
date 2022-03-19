import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/utils/print.dart';
import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part './transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit({
    required ITransactionsCase transactionsCaseImpl,
  })  : _transactionsCaseImpl = transactionsCaseImpl,
        super(
          TransactionListState(
            isLoading: true,
            transactions: [],
            canLoadMore: true,
            offset: 0,
            initialized: false,
            showLoadingIndicator: true,
          ),
        );

  static const int _loadLimit = 40;
  late final StreamSubscription _subscription;
  final ScrollController scrollController = ScrollController();

  bool get _isScrollNearBottom =>
      scrollController.offset >=
          scrollController.position.maxScrollExtent - 300 &&
      !scrollController.position.outOfRange;

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

      _subscription = _transactionsCaseImpl.stream.listen((
        TransactionsChangeData newData,
      ) {
        _refreshWithNewData(newData);
      });

      scrollController.addListener(_scrollListener);

      await fetchTransactions();
    }
  }

  final ITransactionsCase _transactionsCaseImpl;

  List<Transaction> _copyCurrentTransactions() {
    return List.generate(
      state.transactions.length,
      (index) => state.transactions[index].copyWith(),
    );
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

  Future<void> fetchTransactions() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          showLoadingIndicator: state.transactions.isEmpty,
        ),
      );

      final _currentTransactions = [...state.transactions];

      final List<Transaction> _fetchedTransactions =
          await _transactionsCaseImpl.getTransactions(
        limit: _loadLimit,
        offset: state.offset,
        dateTimeRange: state.dateTimeRange,
        categoryUuid: state.categoryUuid,
      );

      _currentTransactions.addAll(_fetchedTransactions);

      emit(
        state.copyWith(
          isLoading: false,
          showLoadingIndicator: false,
          transactions: _currentTransactions,
          canLoadMore: _fetchedTransactions.length == _loadLimit,
          offset: state.offset + _fetchedTransactions.length,
          initialized: true,
        ),
      );
    } catch (e, _) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          showLoadingIndicator: false,
        ),
      );
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsCaseImpl.save(transaction: transaction);
  }

  Future<void> editTransaction({
    required String txId,
    required Transaction newTransaction,
  }) async {
    await _transactionsCaseImpl.edit(
      transactionId: txId,
      newTransaction: newTransaction,
    );
  }

  Future<void> deleteTransaction(String txId) async {
    await _transactionsCaseImpl.delete(transactionId: txId);
  }

  void _refreshWithNewData(TransactionsChangeData newData) {
    final List<Transaction> _transactions = _copyCurrentTransactions();

    printWithBrackets('old transactions length: ${_transactions.length}');

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

      _transactions.addAll(
        newData.addedTransactions.followedBy(
          newData.editedTransactions,
        ),
      );
      printWithBrackets('new transactions length: ${_transactions.length}');

      emit(
        state.copyWith(
          transactions: _transactions,
          showLoadingIndicator: false,
          initialized: true,
          isLoading: false,
          triggerBuilder: true,
        ),
      );
    } else {
      emitEmptyState();
    }
  }

  void emitEmptyState({bool triggerBuilder = true}) {
    emit(
      state.copyWith(
        transactions: [],
        offset: 0,
        isLoading: false,
        showLoadingIndicator: false,
        triggerBuilder: triggerBuilder,
      ),
    );
  }

  Future<void> fillWithMockTransactions() async {
    emit(state.copyWith(isLoading: true, showLoadingIndicator: true));

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
          isLoading: false,
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

  Future<void> onDateTimeRangeChange(DateTimeRange range) async {
    emit(
      state.copyWith(
        dateTimeRange: ValueWrapper(value: range),
        triggerBuilder: false,
      ),
    );

    emitEmptyState(triggerBuilder: false);

    fetchTransactions();
  }

  Future<void> deleteAllTransactions() async {
    emit(
      state.copyWith(
        isLoading: true,
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
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _scrollListener() async {
    if (_isScrollNearBottom && state.canLoadMore && !state.isLoading) {
      fetchTransactions();
    }
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    return super.close();
  }
}
