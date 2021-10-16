import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/routes/edit_transaction/edit_transaction_screen.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('main_appbar_title').tr(),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, EditTransactionScreen.routeName);
          },
          icon: Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
