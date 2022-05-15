import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';
import 'package:my_expenses_planner/domain/models/transactions/transactions_change_data.dart';

abstract class ITransactionsCase {
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  });

  Future<Result<FetchFailure, List<Transaction>>> getLastWeekExpenses();

  Future<Result<FetchFailure, void>> save({
    required Transaction transaction,
  });
  Future<Result<FetchFailure, void>> saveMultiple({
    required List<Transaction> transactions,
  });

  Future<Result<FetchFailure, void>> edit({
    required String transactionId,
    required Transaction newTransaction,
  });

  Future<Result<FetchFailure, void>> delete({
    required String transactionId,
  });
  Future<Result<FetchFailure, void>> deleteAll();

  Future<Result<FetchFailure, void>> fillWithMockTransactions();

  Stream<Result<FetchFailure, TransactionsChangeData>> get stream;
}
