import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            transactionsByDates: {},
            expensesByCategories: {},
            sortedDates: [],
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
        transactionsByDates: {},
        sortedDates: [],
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

      final _transactionsByDates =
          _getTransactionsByDates(_currentTransactions);
      final _sortedDates = _getSortedDates(_transactionsByDates);
      final _expensesByCategories =
          _getExpensesByCategories(_currentTransactions);

      emit(
        state.copyWith(
          isLoading: false,
          showLoadingIndicator: false,
          transactions: _currentTransactions,
          transactionsByDates: _transactionsByDates,
          expensesByCategories: _expensesByCategories,
          sortedDates: _sortedDates,
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

      final _transactionsByDates = _getTransactionsByDates(_transactions);
      final _sortedDates = _getSortedDates(_transactionsByDates);
      final _expenses = _getExpensesByCategories(_transactions);

      emit(
        state.copyWith(
          transactions: _transactions,
          showLoadingIndicator: false,
          transactionsByDates: _transactionsByDates,
          expensesByCategories: _expenses,
          sortedDates: _sortedDates,
          initialized: true,
          isLoading: false,
        ),
      );
    } else {
      emitEmptyState();
    }
  }

  void emitEmptyState() {
    emit(
      state.copyWith(
        transactions: [],
        transactionsByDates: {},
        expensesByCategories: {},
        sortedDates: [],
        initialized: true,
        isLoading: false,
        showLoadingIndicator: false,
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

  Map<DateTime, List<Transaction>> _getTransactionsByDates(
    List<Transaction> transactions,
  ) {
    final Map<DateTime, List<Transaction>> _transactionsByDate = {};

    for (final Transaction _transaction in transactions) {
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

    _transactionsByDate.forEach((key, value) {
      value.sort((a, b) => b.date.compareTo(a.date));
    });

    return _transactionsByDate;
  }

  List<DateTime> _getSortedDates(
      Map<DateTime, List<Transaction>> transactionsByDates) {
    return transactionsByDates.keys.toList()
      ..sort(
        (curDateTime, newDateTime) => newDateTime.compareTo(
          curDateTime,
        ),
      );
  }

  Future<void> _scrollListener() async {
    if (_isScrollNearBottom && state.canLoadMore && !state.isLoading) {
      fetchTransactions();
    }
  }

  Map<String?, List<Transaction>> _getExpensesByCategories(
    List<Transaction> transactions,
  ) {
    final Map<String?, List<Transaction>> _map = {};
    final List<Transaction> expenses = transactions
        .where(
          (element) => element.type == TransactionType.expense,
        )
        .toList();

    for (final Transaction _tr in expenses) {
      final String? _categoryUuid = _tr.categoryUuid;

      if (_map.containsKey(_categoryUuid)) {
        _map[_categoryUuid]!.add(_tr);
      } else {
        _map[_categoryUuid] = [_tr];
      }
    }

    return _map;
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    return super.close();
  }
}
