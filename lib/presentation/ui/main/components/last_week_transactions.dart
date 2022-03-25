import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/extensions/string_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';

import './one_day_transactions_column.dart';
import '../../../cubit/last_week_graphs/last_week_graphs_cubit.dart';

class LastWeekTransactions extends StatelessWidget {
  const LastWeekTransactions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocProvider<LastWeekGraphsCubit>(
      create: (context) => LastWeekGraphsCubit(
        getIt<ITransactionsCase>(),
      )..initialize(),
      child: BlocBuilder<LastWeekGraphsCubit, LastWeekGraphsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else {
            final _now = DateTime.now();

            return Container(
              clipBehavior: Clip.hardEdge,
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: state.isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        7,
                        (int index) {
                          final DateTime date = _now.subtract(
                            Duration(
                              days: index,
                            ),
                          );

                          return InkWell(
                            onTap: () {
                              getIt<AppRouter>().push(
                                PeriodStatisticsRoute(
                                  dateTimeRange: DateTimeRange(
                                    start: date.startOfDay,
                                    end: date.endOfDay,
                                  ),
                                ),
                              );
                            },
                            child: OneDayTransactionsColumn(
                              transactions: state.transactions
                                  .where((element) =>
                                      element.date.isSameDayWith(date))
                                  .toList(),
                              title: DateFormat(
                                'EEE',
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(date).toStandardCase(),
                              maxAmount: state.max,
                            ),
                          );
                        },
                      ).reversed.toList(),
                    ),
            );
          }
        },
      ),
    );
  }
}
