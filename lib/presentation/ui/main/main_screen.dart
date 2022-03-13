import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/transactions_list.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/app_bar.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/drawer.dart';
import 'package:my_expenses_planner/presentation/ui/main/components/last_week_transactions.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionListCubit>(
      create: (context) => TransactionListCubit(
        transactionsCaseImpl: getIt<ITransactionsCase>(),
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: const [
              Flexible(
                flex: 3,
                child: LastWeekTransactions(),
              ),
              Flexible(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TransactionsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
