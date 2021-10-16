import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        return Slidable(
          child: Card(
            child: ListTile(
              title: Text(transaction.title),
              trailing: Text(transaction.amount.toStringAsFixed(2)),
            ),
          ),
          actionExtentRatio: 0.25,
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Colors.orangeAccent,
              icon: Icons.edit,
              onTap: () async {},
            ),
            IconSlideAction(
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async {
                await _onDelete(
                  context: context,
                  transaction: transaction,
                );
              },
            ),
          ],
        );
      },
      groupHeaderBuilder: (Transaction transaction) {
        return Chip(
          label: Text(
            DateFormat('dd.MM.yyyy').format(transaction.date),
          ), //TODO: change to "January 13, 2021/13 января 2021"
        );
      },
    );
  }

  Future<bool?> _onDelete({
    required BuildContext context,
    required Transaction transaction,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete transaction?',
          ), // TODO: localization
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<TransactionsCubit>(context)
                    .deleteTransaction(transaction.id);

                Navigator.of(context).pop();
              },
              child: const Text('Yes'), // TODO: localization
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'), // TODO: localization
            ),
          ],
        );
      },
    );
  }
}
