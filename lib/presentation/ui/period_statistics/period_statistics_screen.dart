import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/app_bar.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/pie_chart_section.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/transaction_list.dart';

class PeriodStatisticsScreen extends StatelessWidget {
  static const String routeName = '/period_statistics';

  PeriodStatisticsScreen({
    DateTimeRange? dateTimeRange,
    Key? key,
  })  : dateTimeRange = dateTimeRange ?? DateTimeRangeFactory.lastMonth(),
        super(key: key);

  final DateTimeRange dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionListCubit>(
      create: (context) => TransactionListCubit(
        transactionsCaseImpl: getIt<ITransactionsCase>(),
      )..initialize(
          dateTimeRange: dateTimeRange,
        ),
      child: Scaffold(
        appBar: const PeriodStatisticsAppBar(),
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: BlocBuilder<TransactionListCubit, TransactionListState>(
            buildWhen: (oldState, newState) {
              return newState.triggerBuilder;
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PieChartSection(
                    expenses: state.transactions,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TransactionList(
                      transactions: state.transactions,
                      errorMessage: state.errorMessage,
                      isLazyLoading: state.isLoading,
                      showLoadingIndicator: state.showLoadingIndicator,
                      dateTimeRange: state.dateTimeRange,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
