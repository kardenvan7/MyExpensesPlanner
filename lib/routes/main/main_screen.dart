import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/routes/main/components/app_bar.dart';
import 'package:my_expenses_planner/routes/main/components/last_week_transactions.dart';
import 'package:my_expenses_planner/routes/main/components/transactions_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainScreenAppBar(),
      body: SafeArea(
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            final TransactionsCubit cubit =
                BlocProvider.of<TransactionsCubit>(context);

            switch (state.type) {
              case TransactionsStateType.initial:
                SchedulerBinding.instance!.addPostFrameCallback(
                  (timeStamp) {
                    cubit.fetchLastTransactions();
                  },
                );

                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: kToolbarHeight),
                  child: const CircularProgressIndicator(),
                );

              case TransactionsStateType.loaded:
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 3,
                        child: LastWeekTransactions(
                          lastWeekTransactions: cubit.lastWeekTransactions,
                        ),
                      ),
                      Flexible(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TransactionsList(
                            transactions: cubit.sortedByDateTransactions,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
