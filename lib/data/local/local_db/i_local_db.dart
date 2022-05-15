import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/core/fetch_failure/fetch_failure.dart';

abstract class ILocalDatabase {
  Future<void> initialize();

  /// Transactions

  Future<Result<FetchFailure, void>> insertTransaction(Transaction transaction);
  Future<Result<FetchFailure, void>> insertMultipleTransactions(
    List<Transaction> transactions,
  );
  Future<Result<FetchFailure, List<Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  });
  Future<Result<FetchFailure, void>> updateTransaction(
    String uuid,
    Transaction newTransaction,
  );
  Future<Result<FetchFailure, void>> deleteTransaction(String uuid);
  Future<Result<FetchFailure, void>> deleteAllTransactions();

  /// Categories

  Future<Result<FetchFailure, void>> insertCategory(
      TransactionCategory category);
  Future<Result<FetchFailure, void>> insertMultipleCategories(
      List<TransactionCategory> categories);
  Future<Result<FetchFailure, TransactionCategory>> getCategoryByUuid(
      String uuid);
  Future<Result<FetchFailure, List<TransactionCategory>>> getCategories();
  Future<Result<FetchFailure, void>> updateCategory(
      String uuid, TransactionCategory newCategory);
  Future<Result<FetchFailure, void>> deleteCategory(String uuid);
  Future<Result<FetchFailure, void>> deleteAllCategories();
}
