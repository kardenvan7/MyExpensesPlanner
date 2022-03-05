import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
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
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          return state.transactions.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: Platform.isIOS ? 30 : 10,
                  ),
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
                                ? AppLocalizationsWrapper.of(context).today
                                : _currentDate.isYesterday
                                    ? AppLocalizationsWrapper.of(context)
                                        .yesterday
                                    : DateFormat.yMMMMd(
                                        Localizations.localeOf(context)
                                            .toLanguageTag(),
                                      ).format(_currentDate),
                          ),
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
                        ),
                      ],
                    );
                  },
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: kToolbarHeight),
                  child: Center(
                    child: Text(
                      AppLocalizationsWrapper.of(context)
                          .empty_transaction_list_placeholder_text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
