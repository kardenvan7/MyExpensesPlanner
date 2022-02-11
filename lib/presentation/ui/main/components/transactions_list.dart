import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/transactions_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionListCubit>(
      create: (context) => TransactionListCubit(
        transactionsCaseImpl: getIt<ITransactionsCase>(),
      )..fetchLastTransactions(),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          return state.transactions.isNotEmpty
              ? GroupedListView(
                  order: GroupedListOrder.DESC,
                  elements: state.transactions,
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
                  child: const Center(
                    child: Text(
                      'You have no transactions yet.\n\nGo ahead and add some by pressing "+" button in the top right corner of the screen',
                      // TODO: localization
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
