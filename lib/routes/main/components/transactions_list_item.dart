import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/routes/edit_transaction/edit_transaction_screen.dart';

class TransactionsListItem extends StatelessWidget {
  const TransactionsListItem({required this.transaction, Key? key})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
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
          onTap: () async {
            Navigator.pushNamed(
              context,
              EditTransactionScreen.routeName,
              arguments: transaction,
            );
          },
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
            'deleteTransactionConfirmationQuestion',
          ).tr(),
          actions: [
            TextButton(
              onPressed: () {
                _onDeleteDenied(context);
              },
              child: const Text('no').tr(),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(context);
              },
              child: const Text('yes').tr(),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteConfirmed(BuildContext context) {
    try {
      BlocProvider.of<TransactionsCubit>(context)
          .deleteTransaction(transaction.txId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete transaction',
          ),
        ), // TODO: localization
      );
    }
    Navigator.of(context).pop();
  }

  void _onDeleteDenied(BuildContext context) {
    Navigator.of(context).pop();
  }
}
