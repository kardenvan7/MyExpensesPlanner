import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({required this.transactions, Key? key})
      : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      order: GroupedListOrder.DESC,
      elements: transactions,
      groupBy: (Transaction element) => DateTime(
        element.date.year,
        element.date.month,
        element.date.day,
      ),
      itemBuilder: (BuildContext context, Transaction transaction) {
        return Dismissible(
          key: ValueKey(transaction.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (DismissDirection direction) async {
            return _onConfirmDismiss(
              context: context,
              direction: direction,
              transaction: transaction,
            );
          },
          onDismissed: (DismissDirection direction) {},
          child: Card(
            child: ListTile(
              title: Text(transaction.title),
              trailing: Text(transaction.amount.toStringAsFixed(2)),
            ),
          ),
        );
      },
      groupHeaderBuilder: (Transaction transaction) {
        return Chip(
          label: Text(DateFormat('dd.MM.yyyy').format(transaction.date)),
        );
      },
    );
  }

  Future<bool?> _onConfirmDismiss({
    required BuildContext context,
    required DismissDirection direction,
    required Transaction transaction,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<TransactionsCubit>(context)
                    .deleteTransaction(transaction.id);

                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
