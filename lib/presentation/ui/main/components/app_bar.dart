import 'package:flutter/material.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
import 'package:my_expenses_planner/presentation/ui/edit_transaction/edit_transaction_screen.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizationsWrapper.of(context).main_app_bar_title),
      actions: [
        IconButton(
          onPressed: () {
            getIt<AppRouter>().pushNamed(EditTransactionScreen.routeName);
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
