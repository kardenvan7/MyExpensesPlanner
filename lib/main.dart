import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/languages/config.dart';
import 'package:my_expenses_planner/providers/transactions/mock_transactions_provider.dart';
import 'package:my_expenses_planner/routes/add_transaction/add_transaction_screen.dart';
import 'package:my_expenses_planner/routes/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    const ConfiguredEasyLocalization(
      child: MyExpensesPlanner(),
    ),
  );
}

class MyExpensesPlanner extends StatelessWidget {
  const MyExpensesPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsCubit>(
      create: (BuildContext context) => TransactionsCubit(
        transactionsProvider: MockTransactionsProvider(),
      ), // TODO: getIt
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const MainScreen(),
        routes: {
          MainScreen.routeName: (BuildContext context) => const MainScreen(),
          AddTransactionScreen.routeName: (BuildContext context) =>
              const AddTransactionScreen(),
        },
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.purple,
                secondary: Colors.orangeAccent,
              ),
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                colorScheme:
                    Theme.of(context).buttonTheme.colorScheme!.copyWith(
                          primary: Colors.orangeAccent,
                        ),
                buttonColor: Colors.orangeAccent,
              ),
        ),
      ),
    );
  }
}
