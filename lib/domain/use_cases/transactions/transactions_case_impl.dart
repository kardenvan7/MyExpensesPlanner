import 'package:my_expenses_planner/data/repositories/transactions/sqflite_transactions_repository.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class TransactionsCaseImpl implements ITransactionsCase {
  TransactionsCaseImpl({
    required SqfliteTransactionsRepository sqfliteTransactionsRepository,
  }) : _sqfliteTransactionsRepository = sqfliteTransactionsRepository;

  final SqfliteTransactionsRepository _sqfliteTransactionsRepository;

  @override
  Future<List<Transaction>> getLastTransactions({
    int limit = 40,
    int offset = 0,
  }) async {
    return _sqfliteTransactionsRepository.getLastTransactions(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<void> edit({
    required String transactionId,
    required Transaction newTransaction,
  }) async {
    _sqfliteTransactionsRepository.edit(
      transactionId: transactionId,
      newTransaction: newTransaction,
    );
  }

  @override
  Future<void> save({
    required Transaction transaction,
  }) async {
    _sqfliteTransactionsRepository.save(transaction: transaction);
  }

  @override
  Future<void> delete({
    required String transactionId,
  }) async {
    _sqfliteTransactionsRepository.delete(transactionId: transactionId);
  }
}
