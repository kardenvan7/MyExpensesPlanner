import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/transactions_list.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/app_bar.dart';
import 'package:my_expenses_planner/presentation/ui/period_statistics/components/pie_chart_section.dart';

class PeriodStatisticsScreen extends StatelessWidget {
  static const String routeName = '/period_statistics';

  const PeriodStatisticsScreen({
    required this.dateTimeRange,
    Key? key,
  }) : super(key: key);

  final DateTimeRange dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionListCubit>(
      create: (context) => TransactionListCubit(
        transactionsCaseImpl: getIt<ITransactionsCase>(),
      )..initialize(
          dateTimeRange: dateTimeRange,
        ),
      child: BlocListener<TransactionListCubit, TransactionListState>(
        listener: (context, state) {
          if (state.transactions.isEmpty) {
            getIt<AppRouter>().pop();
          }
        },
        child: Scaffold(
          appBar: PeriodStatisticsAppBar(
            dateTimeRange: dateTimeRange,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PieChartSection(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TransactionsList(
                    dateTimeRange: dateTimeRange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
