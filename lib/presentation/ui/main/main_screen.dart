import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/pie_chart_section.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/app_bar.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/drawer.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/last_week_transactions.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/transactions_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionListCubit>(
      create: (context) => TransactionListCubit(
        transactionsCaseImpl: getIt<ITransactionsCase>(),
        loadLimit: 40,
      )..initialize(),
      child: Scaffold(
        appBar: const MainScreenAppBar(),
        drawer: const MainScreenDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            getIt<AppRouter>().pushNamed(EditTransactionScreen.routeName);
          },
        ),
        body: BlocBuilder<TransactionListCubit, TransactionListState>(
          buildWhen: (oldState, newState) {
            return newState.triggerBuilder;
          },
          builder: (context, state) {
            final _cubit = BlocProvider.of<TransactionListCubit>(context);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              controller: _cubit.scrollController,
              child: Column(
                children: [
                  if (state.dateTimeRange != null)
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              state.dateTimeRange!.toFormattedString(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.center,
                            onPressed: () {
                              _cubit.onDateTimeRangeChange(null);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state.transactions.isEmpty && state.dateTimeRange != null)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 300),
                      child: Text(
                        AppLocalizationsWrapper.of(context)
                            .no_statistics_for_period,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state.dateTimeRange == null)
                          const SizedBox(
                            height: 250,
                            child: LastWeekTransactions(),
                          )
                        else
                          PieChartSection(
                            transactions: state.transactions,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TransactionsList(
                            transactionsListState: state,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
