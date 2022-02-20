import 'dart:async';

import 'package:collection/collection.dart';
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
            isLoading: false,
            transactions: [],
          ),
        );

  bool initialized = false;
  late final StreamSubscription _subscription;

  Future<void> initialize() async {
    if (!initialized) {
      _subscription = _transactionsCaseImpl.stream.listen((
        TransactionsChangeData newData,
      ) {
        _refreshWithNewData(newData);
      });

      fetchLastTransactions();

      initialized = true;
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
    fetchLastTransactions();
  }

  Future<void> fetchLastTransactions() async {
    try {
      emit(
        TransactionListState(
          isLoading: true,
          transactions: [],
        ),
      );

      final List<Transaction> _transactions =
          await _transactionsCaseImpl.getTransactions();

      emit(
        TransactionListState(
          isLoading: false,
          transactions: _transactions,
        ),
      );
    } catch (e, st) {
      print(e);
      print(st);
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
    _transactionsCaseImpl.delete(transactionId: txId);
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

    emit(state.copyWith(transactions: _transactions));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
