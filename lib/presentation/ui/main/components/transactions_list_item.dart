import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

import '../../../cubit/category_list/category_list_cubit.dart';
import '../../../cubit/transaction_list/transaction_list_cubit.dart';

class TransactionsListItem extends StatelessWidget {
  const TransactionsListItem({required this.transaction, Key? key})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).listTileTheme.tileColor,
        child: Row(
          children: [
            BlocBuilder<CategoryListCubit, CategoryListState>(
              builder: (context, state) {
                final TransactionCategory? _category =
                    state.categories.firstWhereOrNull(
                  (element) => element.uuid == transaction.categoryUuid,
                );

                return Container(
                  width: 70,
                  height: 50,
                  color: _category?.color,
                  child: Center(
                    child: Text(
                      _category?.name ?? '',
                      style: TextStyle(
                        color: _category?.color.isBright ?? true
                            ? Colors.black
                            : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
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
              getIt<AppRouter>().push(
                EditTransactionRoute(transaction: transaction),
              );
              // Navigator.pushNamed(
              //   context,
              //   EditTransactionScreen.routeName,
              //   arguments: transaction,
              // );
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
          title: Text(
            AppLocalizationsWrapper.of(context)
                .delete_transaction_confirmation_question,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _onDeleteDenied(dialogContext);
              },
              child: Text(AppLocalizationsWrapper.of(context).no),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(context, dialogContext);
              },
              child: Text(
                AppLocalizationsWrapper.of(context).yes,
              ),
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
