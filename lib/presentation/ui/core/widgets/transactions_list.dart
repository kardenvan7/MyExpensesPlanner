import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/datetime_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/transactions_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    this.dateTimeRange,
    this.categoryUuid,
    Key? key,
  }) : super(key: key);

  final DateTimeRange? dateTimeRange;
  final String? categoryUuid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListCubit, TransactionListState>(
      buildWhen: (oldState, newState) {
        return newState.triggerBuilder;
      },
      builder: (context, state) {
        if (state.errorWhileInitializing) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!),
                ],
              ),
            ),
          );
        }

        if (state.showLoadingIndicator) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }

        return state.transactions.isNotEmpty
            ? ListView.separated(
                controller: BlocProvider.of<TransactionListCubit>(context)
                    .scrollController,
                padding: EdgeInsets.only(
                  bottom: Platform.isIOS ? 30 : 10,
                ),
                shrinkWrap: true,
                itemCount: state.sortedDates.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  final DateTime _currentDate = state.sortedDates[index];
                  final List<Transaction> _currentDateTransactions =
                      state.transactionsByDates[_currentDate]!;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isDatePicked(
                        date: _currentDate,
                        pickedRange: state.dateTimeRange,
                      ))
                        InkWell(
                          onTap: () {
                            _onDateChipTap(
                              date: _currentDate,
                              pickedRange: state.dateTimeRange,
                            );
                          },
                          child: Chip(
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
                        ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _currentDateTransactions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return TransactionsListItem(
                            transaction: _currentDateTransactions[index],
                          );
                        },
                        separatorBuilder: (_, __) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      if (state.hasError) Text(state.errorMessage!),
                      if (state.isLoading)
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    ],
                  );
                },
              )
            : Container(
                margin: const EdgeInsets.only(bottom: kToolbarHeight),
                child: Center(
                  child: Text(
                    AppLocalizationsWrapper
                        .keys.empty_transaction_list_placeholder_text,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
      },
    );
  }

  void _onDateChipTap({
    required DateTime date,
    required DateTimeRange? pickedRange,
  }) {
    if (!_isDatePicked(date: date, pickedRange: pickedRange)) {
      getIt<AppRouter>().push(
        PeriodStatisticsRoute(
          dateTimeRange: DateTimeRange(
            start: date,
            end: date.add(const Duration(days: 1)).subtract(
                  const Duration(milliseconds: 1),
                ),
          ),
        ),
      );
    }
  }

  bool _isDatePicked({
    required DateTime date,
    required DateTimeRange? pickedRange,
  }) {
    if (pickedRange == null) {
      return false;
    }

    return date.isSameDayWith(pickedRange.start) &&
        date.isSameDayWith(pickedRange.end);
  }
}
