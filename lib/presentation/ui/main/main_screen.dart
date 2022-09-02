import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
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
        transactionsCaseImpl: DI.instance<ITransactionsCase>(),
        loadLimit: 40,
      )..initialize(),
      child: Scaffold(
        appBar: const MainScreenAppBar(),
        drawer: const MainScreenDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            DI.instance<AppRouter>().pushNamed(EditTransactionScreen.routeName);
          },
        ),
        body: BlocConsumer<TransactionListCubit, TransactionListState>(
          listenWhen: (oldState, newState) =>
              oldState.categoryUuid != newState.categoryUuid ||
              oldState.dateTimeRange != newState.dateTimeRange ||
              oldState.onlyIncome != newState.onlyIncome,
          listener: (context, __) {
            BlocProvider.of<TransactionListCubit>(context)
                .scrollController
                .animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                );
          },
          buildWhen: (oldState, newState) {
            return newState.triggerBuilder;
          },
          builder: (context, state) {
            final _cubit = BlocProvider.of<TransactionListCubit>(context);
            final pickedCategory = context
                .read<CategoryListCubit>()
                .state
                .categories
                .firstWhereOrNull(
                  (element) => element.uuid == state.categoryUuid,
                );

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
                  if (pickedCategory != null)
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: pickedCategory.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              pickedCategory.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: pickedCategory.color.isBright
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.center,
                            onPressed: () {
                              _cubit.setCategoryUuid(null);
                            },
                            icon: Icon(
                              Icons.close,
                              color: pickedCategory.color.isBright
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state.onlyIncome)
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizationsFacade.of(context).income,
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
                              _cubit.setOnlyIncome(false);
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
                        AppLocalizationsFacade.of(context)
                            .no_statistics_for_period,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state.dateTimeRange == null &&
                            state.categoryUuid == null &&
                            !state.onlyIncome)
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
