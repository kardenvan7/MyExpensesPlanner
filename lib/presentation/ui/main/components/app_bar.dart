import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/constants.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizationsWrapper.of(context).main_app_bar_title),
      actions: !ConfigConstants.isTest
          ? null
          : [
              IconButton(
                onPressed: () {
                  getIt<ITransactionsCase>().deleteAll();
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  getIt<ITransactionsCase>().fillWithMockTransactions();
                },
                icon: const Icon(Icons.add),
              ),
            ],
    );
  }
}
