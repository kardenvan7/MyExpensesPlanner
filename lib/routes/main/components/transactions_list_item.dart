import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/models/transaction.dart';

class TransactionsListItem extends StatelessWidget {
  const TransactionsListItem({required this.transaction, Key? key})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${transaction.amount} р.'),
        ],
      ),
      title: Text(transaction.title),
      subtitle: Text(DateFormat('dd.MM.yyyy').format(transaction.date)),
    );
  }
}
