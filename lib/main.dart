import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/languages/config.dart';
import 'package:my_expenses_planner/local_db/sqflite_local_db.dart';
import 'package:my_expenses_planner/models/transaction.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/providers/transactions/sqflite_transactions_provider.dart';
import 'package:my_expenses_planner/routes/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/routes/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/routes/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SqfliteDatabaseProvider().initDatabase();

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
        transactionsProvider: SqfliteTransactionsProvider(),
      ), // TODO: getIt
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const MainScreen(),
        onGenerateRoute: _onGenerateRoute,
        theme: ThemeData(
          textTheme: TextTheme(
            headline3: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
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

Route _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainScreen.routeName:
      return MaterialPageRoute(
        builder: (BuildContext context) => const MainScreen(),
      );

    case EditTransactionScreen.routeName:
      return MaterialPageRoute(
        builder: (BuildContext context) => EditTransactionScreen(
          transaction: settings.arguments as Transaction?,
        ),
      );

    case EditCategoryScreen.routeName:
      final TransactionCategory? category =
          settings.arguments as TransactionCategory?;

      return MaterialPageRoute(
        builder: (BuildContext context) => EditCategoryScreen(
          category: category,
        ),
      );

    default:
      throw Exception();
  }
}
