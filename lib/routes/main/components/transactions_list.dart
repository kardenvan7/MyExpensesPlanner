import 'package:flutter/material.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/routes/main/components/transactions_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({required this.transactions, Key? key})
      : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: transactions
            .map(
              (transaction) => Column(
                children: [
                  TransactionsListItem(transaction: transaction),
                  const Divider(
                    height: 0,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

// TODO: check why performance drops
// ListView.separated(
// shrinkWrap: true,
// itemBuilder: (context, index) =>
//     TransactionsListItem(transaction: transactions[index]),
// separatorBuilder: (context, index) => const Divider(height: 0),
// itemCount: transactions.length,
// )
