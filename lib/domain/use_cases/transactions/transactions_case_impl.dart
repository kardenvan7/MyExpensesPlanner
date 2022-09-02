import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/categories/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions/transactions_change_data.dart';
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class TransactionsCaseImpl implements ITransactionsCase {
  TransactionsCaseImpl({
    required ITransactionsRepository transactionsRepository,
  }) : _transactionsRepository = transactionsRepository;

  final ITransactionsRepository _transactionsRepository;

  final StreamController<Result<FetchFailure, TransactionsChangeData>>
      streamController = StreamController<
          Result<FetchFailure, TransactionsChangeData>>.broadcast();

  @override
  Stream<Result<FetchFailure, TransactionsChangeData>> get stream =>
      streamController.stream;

  @override
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  }) async {
    return _transactionsRepository.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
      type: type,
    );
  }

  @override
  Future<Result<FetchFailure, void>> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    final _result = await _transactionsRepository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              editedTransactions: [
                newTransaction,
              ],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> save({
    required Transaction transaction,
  }) async {
    final _result = await _transactionsRepository.save(
      transaction: transaction,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              addedTransactions: [
                transaction,
              ],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete({
    required String transactionId,
  }) async {
    final _result = await _transactionsRepository.delete(
      transactionId: transactionId,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              deletedTransactionsUuids: [
                transactionId,
              ],
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, List<Transaction>>> getLastWeekExpenses() async {
    final DateTime _now = DateTime.now();
    final DateTime _startDate = _now.startOfDay.subtract(
      const Duration(
        days: 6,
      ),
    );

    return _transactionsRepository.getTransactions(
      dateTimeRange: DateTimeRange(start: _startDate, end: _now.endOfDay),
      type: TransactionType.expense,
    );
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple({
    required List<Transaction> transactions,
  }) async {
    final _result = await _transactionsRepository.saveMultiple(
      transactions: transactions,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              addedTransactions: transactions,
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteAll() async {
    final _result = await _transactionsRepository.deleteAll();

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              deletedAll: true,
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> fillWithMockTransactions() async {
    final List<Transaction> _transactions = [];

    for (int i = 0; i < 40; i++) {
      await Future.delayed(
        const Duration(milliseconds: 200),
        () {
          final DateTime _date = DateTime.now().subtract(
            Duration(hours: 12 * i),
          );

          _transactions.add(
            Transaction(
              uuid: _date.millisecondsSinceEpoch.toString(),
              amount: (i + 1) * 10,
              title: 'Transaction ${i + 1}',
              date: _date,
              type:
                  i % 2 == 0 ? TransactionType.expense : TransactionType.income,
              categoryUuid: TransactionCategory.empty().uuid,
            ),
          );
        },
      );
    }

    final _result = await _transactionsRepository.saveMultiple(
      transactions: _transactions,
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (_) {
        streamController.add(
          Result.success(
            TransactionsChangeData(
              addedTransactions: _transactions,
            ),
          ),
        );

        return Result.success(null);
      },
    );
  }
}
