import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/datetime_extensions.dart';
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
      )..initialize(),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          return state.transactions.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.sortedDates.length,
                  itemBuilder: (context, index) {
                    final _currentDate = state.sortedDates[index];
                    final List<Transaction> _currentDateTransactions =
                        state.transactionsByDate[_currentDate]!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            _currentDate.isToday
                                ? 'Today'
                                : _currentDate.isYesterday
                                    ? 'Yesterday'
                                    : DateFormat('dd.MM.yyyy')
                                        .format(_currentDate),
                          ), //TODO: change to "January 13, 2021/13 января 2021"
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _currentDateTransactions.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return TransactionsListItem(
                              transaction: _currentDateTransactions[index],
                            );
                          },
                        )
                      ],
                    );
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
