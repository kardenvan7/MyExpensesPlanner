import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/datetime_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
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
      _subscription = _transactionsCaseImpl.stream.listen((event) {
        fetchLastTransactions();
      });

      fetchLastTransactions();

      initialized = true;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
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
    final List<Transaction> _transactions = _copyCurrentTransactions();
    await _transactionsCaseImpl.save(transaction: transaction);

    _transactions.add(transaction);

    emit(
      TransactionListState(
        isLoading: false,
        transactions: _transactions,
      ),
    );
  }

  Future<void> editTransaction({
    required String txId,
    required Transaction newTransaction,
  }) async {
    final List<Transaction> _transactions = _copyCurrentTransactions();
    final int index =
        _transactions.indexWhere((element) => element.uuid == txId);

    await _transactionsCaseImpl.edit(
      transactionId: txId,
      newTransaction: newTransaction,
    );

    _transactions[index] = newTransaction;

    emit(
      TransactionListState(
        isLoading: false,
        transactions: _transactions,
      ),
    );
  }

  Future<void> deleteTransaction(String txId) async {
    final List<Transaction> _transactions = _copyCurrentTransactions();
    _transactionsCaseImpl.delete(transactionId: txId);

    _transactions.removeWhere((transaction) => transaction.uuid == txId);

    emit(
      TransactionListState(
        isLoading: false,
        transactions: _transactions,
      ),
    );
  }
}
