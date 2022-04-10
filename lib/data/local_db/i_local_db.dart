import 'package:flutter/material.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/data/models/transaction_category.dart';

abstract class ILocalDatabase {
  Future<void> initialize();

  /// Transactions

  Future<void> insertTransaction(Transaction transaction);
  Future<void> insertMultipleTransactions(List<Transaction> transactions);
  Future<List<Transaction>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    TransactionType? type,
  });
  Future<void> updateTransaction(String uuid, Transaction newTransaction);
  Future<void> deleteTransaction(String uuid);
  Future<void> deleteAllTransactions();

  /// Categories

  Future<void> insertCategory(TransactionCategory category);
  Future<void> insertMultipleCategories(List<TransactionCategory> categories);
  Future<TransactionCategory?> getCategoryByUuid(String uuid);
  Future<List<TransactionCategory>> getCategories();
  Future<void> updateCategory(String uuid, TransactionCategory newCategory);
  Future<void> deleteCategory(String uuid);
  Future<void> deleteAllCategories();
}
