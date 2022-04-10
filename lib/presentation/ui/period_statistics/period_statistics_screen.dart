import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/pie_chart_section.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/app_bar.dart';
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
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        buildWhen: (oldState, newState) {
          return newState.triggerBuilder;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: PeriodStatisticsAppBar(
              dateTimeRange: state.dateTimeRange!,
            ),
            body: state.transactions.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizationsFacade.of(context)
                          .no_statistics_for_period,
                      textAlign: TextAlign.center,
                    ),
                  )
                : state.showLoadingIndicator
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : ListView(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 20),
                        controller:
                            BlocProvider.of<TransactionListCubit>(context)
                                .scrollController,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: 100,
                              maxHeight: 500,
                            ),
                            child: PieChartSection(
                              transactions: state.transactions,
                              isLoading: state.showLoadingIndicator,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TransactionList(
                            transactions: state.transactions,
                            onDeleteConfirmed:
                                BlocProvider.of<TransactionListCubit>(context)
                                    .deleteTransaction,
                            errorMessage: state.errorMessage,
                            isLazyLoading: state.isLazyLoading,
                            showLoadingIndicator: state.showLoadingIndicator,
                            dateTimeRange: state.dateTimeRange,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
