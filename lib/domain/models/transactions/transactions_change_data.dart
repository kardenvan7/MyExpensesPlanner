import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';

class TransactionsChangeData {
  TransactionsChangeData({
    List<Transaction>? addedTransactions,
    List<Transaction>? editedTransactions,
    List<String>? deletedTransactionsUuids,
    this.deletedAll = false,
  })  : addedTransactions = addedTransactions ?? [],
        editedTransactions = editedTransactions ?? [],
        deletedTransactionsUuids = deletedTransactionsUuids ?? [];

  final List<Transaction> addedTransactions;
  final List<Transaction> editedTransactions;
  final List<String> deletedTransactionsUuids;
  final bool deletedAll;
}
