import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';

class TransactionsListItem extends StatelessWidget {
  const TransactionsListItem({required this.transaction, Key? key})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Container(
              width: 70,
              height: 50,
              color: transaction.category?.color,
              child: Center(
                child: Text(
                  transaction.category?.name ?? '',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  transaction.title,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: Text(
                transaction.amount.toStringAsFixed(2),
              ),
            ),
          ],
        ),
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.orangeAccent,
            icon: Icons.edit,
            onPressed: (BuildContext context) async {
              Navigator.pushNamed(
                context,
                EditTransactionScreen.routeName,
                arguments: transaction,
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (BuildContext onPressedContext) async {
              await _onDelete(
                context: context,
                transaction: transaction,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _onDelete({
    required BuildContext context,
    required Transaction transaction,
  }) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'delete_transaction_confirmation_question',
          ).tr(),
          actions: [
            TextButton(
              onPressed: () {
                _onDeleteDenied(dialogContext);
              },
              child: const Text('no').tr(),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(context, dialogContext);
              },
              child: const Text('yes').tr(),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteConfirmed(
    BuildContext contextWithCubit,
    BuildContext dialogContext,
  ) {
    BlocProvider.of<TransactionListCubit>(contextWithCubit)
        .deleteTransaction(transaction.uuid);
    Navigator.of(dialogContext).pop();
  }

  void _onDeleteDenied(BuildContext context) {
    Navigator.of(context).pop();
  }
}
