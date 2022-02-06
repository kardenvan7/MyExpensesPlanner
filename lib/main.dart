import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/localization/localization.dart';
import 'package:my_expenses_planner/data/local_db/database_wrapper.dart';
import 'package:my_expenses_planner/data/repositories/categories/i_categories_repository.dart';
import 'package:my_expenses_planner/data/repositories/transactions/i_transactions_repository.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/categories_case_impl.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/transactions_case_impl.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';
import 'package:my_expenses_planner/presentation/ui/main/main_screen.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await configureDependencies();

      try {
        await EasyLocalization.ensureInitialized();
        await getIt<DatabaseWrapper>().initDatabase();
      } catch (e) {
        exit(1);
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };

      runApp(
        const ConfiguredEasyLocalization(
          child: MyExpensesPlanner(),
        ),
      );
    },
    (Object error, StackTrace stack) {
      print(error);
      print(stack);
    },
  );
}

class MyExpensesPlanner extends StatelessWidget {
  const MyExpensesPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionListCubit>(
          create: (_) => TransactionListCubit(
            transactionsCaseImpl: TransactionsCaseImpl(
              transactionsRepository: getIt<ITransactionsRepository>(),
            ),
          )..fetchLastTransactions(),
        ),
        BlocProvider<CategoryListCubit>(
          create: (_) => CategoryListCubit(
            categoriesCaseImpl: CategoriesCaseImpl(
              categoriesRepository: getIt<ICategoriesRepository>(),
            ),
          )..fetchCategories(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const MainScreen(),
        onGenerateRoute: _onGenerateRoute,
        theme: ThemeData(
          textTheme: const TextTheme(
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
