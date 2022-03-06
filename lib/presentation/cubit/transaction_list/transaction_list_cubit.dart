import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            sortedDates: [],
            canLoadMore: true,
            offset: 0,
            initialized: false,
          ),
        );

  static const int _loadLimit = 40;
  late final StreamSubscription _subscription;
  final ScrollController scrollController = ScrollController();

  bool get _nearBottom =>
      scrollController.offset >=
          scrollController.position.maxScrollExtent - 300 &&
      !scrollController.position.outOfRange;

  Future<void> initialize() async {
    if (!state.initialized) {
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
      (index) => state.transactions[index].copyWith(
        uuid: state.transactions[index].uuid,
      ),
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
      ),
    );

    await fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );

      final _currentTransactions = [...state.transactions];

      final List<Transaction> _fetchedTransactions =
          await _transactionsCaseImpl.getTransactions(
        limit: _loadLimit,
        offset: state.offset,
      );

      _currentTransactions.addAll(_fetchedTransactions);

      final _transactionsByDates =
          _getTransactionsByDates(_currentTransactions);
      final _sortedDates = _getSortedDates(_transactionsByDates);

      emit(
        state.copyWith(
          isLoading: false,
          transactions: _currentTransactions,
          transactionsByDates: _transactionsByDates,
          sortedDates: _sortedDates,
          canLoadMore: _fetchedTransactions.length == _loadLimit,
          offset: state.offset + _fetchedTransactions.length,
          initialized: true,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
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

    final _transactionsByDates = _getTransactionsByDates(_transactions);
    final _sortedDates = _getSortedDates(_transactionsByDates);

    emit(
      state.copyWith(
        transactions: _transactions,
        transactionsByDates: _transactionsByDates,
        sortedDates: _sortedDates,
      ),
    );
  }

  Future<void> fillWithMockTransactions() async {
    emit(state.copyWith(isLoading: true));

    try {
      final List<Transaction> _transactions = List.generate(
        20,
        (index) => Transaction(
          uuid: DateTime.now().microsecondsSinceEpoch.toString(),
          amount: ((index + 1) * 1.2).toInt().toDouble(),
          title: 'Transaction',
          date: DateTime.now(),
        ),
      );

      await _transactionsCaseImpl.saveMultiple(transactions: _transactions);

      emit(state.copyWith(isLoading: false));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
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
    if (_nearBottom && state.canLoadMore && !state.isLoading) {
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
