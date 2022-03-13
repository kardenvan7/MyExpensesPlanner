import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/string_extensions.dart';
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
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).listTileTheme.tileColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Slidable(
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
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              if (transaction.isIncome)
                Container(
                  width: 90,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: AutoSizeText(
                      AppLocalizationsWrapper.of(context).income,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                      minFontSize: 11,
                      maxFontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                BlocBuilder<CategoryListCubit, CategoryListState>(
                  builder: (context, state) {
                    final TransactionCategory? _category =
                        state.categories.firstWhereOrNull(
                      (element) => element.uuid == transaction.categoryUuid,
                    );

                    return Container(
                      width: 90,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: _category?.color,
                      child: Center(
                        child: AutoSizeText(
                          _category?.name ??
                              AppLocalizationsWrapper.of(context)
                                  .without_category,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 14,
                                    color: _category?.color.isBright ?? true
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                          minFontSize: 11,
                          maxFontSize: 16,
                          textAlign: TextAlign.center,
                          maxLines: _category?.name.wordCount,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                child: Text(
                  _getAmountText(transaction: transaction),
                  style: TextStyle(
                    fontSize: 15,
                    color: transaction.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAmountText({required Transaction transaction}) {
    final _sign = _getSignByType(type: transaction.type);

    return '$_sign '
        '${transaction.amount.toStringAsFixed(
      transaction.amount < 99
          ? 2
          : transaction.amount < 999
              ? 1
              : 0,
    )}';
  }

  String _getSignByType({required TransactionType type}) {
    switch (type) {
      case TransactionType.income:
        return '+';

      case TransactionType.expense:
        return '-';
    }
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
            AppLocalizationsWrapper
                .keys.delete_transaction_confirmation_question,
          ),
          actions: [
            TextButton(
              onPressed: _onDeleteDenied,
              child: Text(AppLocalizationsWrapper.of(context).no),
            ),
            TextButton(
              onPressed: () {
                _onDeleteConfirmed(context);
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
  ) {
    BlocProvider.of<TransactionListCubit>(contextWithCubit)
        .deleteTransaction(transaction.uuid);

    getIt<AppRouter>().pop();
  }

  void _onDeleteDenied() {
    getIt<AppRouter>().pop();
  }
}
