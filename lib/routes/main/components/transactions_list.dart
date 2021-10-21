import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/routes/main/components/transactions_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    required this.transactions,
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return transactions.isNotEmpty
        ? GroupedListView(
            order: GroupedListOrder.DESC,
            elements: transactions,
            groupBy: (Transaction element) => DateTime(
              element.date.year,
              element.date.month,
              element.date.day,
            ),
            groupHeaderBuilder: (Transaction transaction) {
              return Chip(
                label: Text(
                  DateFormat('dd.MM.yyyy').format(transaction.date),
                ), //TODO: change to "January 13, 2021/13 января 2021"
              );
            },
            itemBuilder: (BuildContext context, Transaction transaction) {
              return TransactionsListItem(transaction: transaction);
            },
          )
        : Container(
            margin: const EdgeInsets.only(bottom: kToolbarHeight),
            child: Center(
              child: Text(
                'You have no transactions yet.\n\nGo ahead and add some by pressing "+" button in the top right corner of the screen', // TODO: localization
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
