import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/utils/result.dart';
import 'package:my_expenses_planner/data/local/providers/transactions/i_transactions_local_provider.dart';
import 'package:my_expenses_planner/data/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/fetch_failure.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart' as domain;
import 'package:my_expenses_planner/domain/repositories_interfaces/i_transactions_repository.dart';

class TransactionsRepository implements ITransactionsRepository {
  TransactionsRepository({
    required ITransactionsLocalProvider localProvider,
  }) : _localProvider = localProvider;

  final ITransactionsLocalProvider _localProvider;

  @override
  Future<Result<FetchFailure, List<domain.Transaction>>> getTransactions({
    int? limit,
    int? offset,
    DateTimeRange? dateTimeRange,
    String? categoryUuid,
    domain.TransactionType? type,
  }) async {
    final _result = await _localProvider.getTransactions(
      limit: limit,
      offset: offset,
      dateTimeRange: dateTimeRange,
      categoryUuid: categoryUuid,
      type: type == null ? null : TransactionTypeFactory.fromName(type.name),
    );

    return _result.fold(
      onFailure: (failure) => failure.when(
        unknown: () => Result.failure(failure),
        notFound: () => Result.failure(failure),
      ),
      onSuccess: (transactions) {
        return Result.success(
          List.generate(
            transactions.length,
            (index) => transactions[index].toDomainTransaction(),
          ),
        );
      },
    );
  }

  @override
  Future<Result<FetchFailure, void>> edit({
    required String transactionId,
    required domain.Transaction newTransaction,
  }) async {
    return _localProvider.edit(
      transactionId: transactionId,
      newTransaction: Transaction.fromDomainTransaction(newTransaction),
    );
  }

  @override
  Future<Result<FetchFailure, void>> save({
    required domain.Transaction transaction,
  }) async {
    return _localProvider.save(
      transaction: Transaction.fromDomainTransaction(transaction),
    );
  }

  @override
  Future<Result<FetchFailure, void>> delete({
    required String transactionId,
  }) async {
    return _localProvider.delete(transactionId: transactionId);
  }

  @override
  Future<Result<FetchFailure, void>> saveMultiple({
    required List<domain.Transaction> transactions,
  }) async {
    return _localProvider.saveMultiple(
      transactions: List.generate(
        transactions.length,
        (index) => Transaction.fromDomainTransaction(transactions[index]),
      ),
    );
  }

  @override
  Future<Result<FetchFailure, void>> deleteAll() async {
    return _localProvider.deleteAll();
  }
}
