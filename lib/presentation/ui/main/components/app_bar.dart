import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';

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
            BlocProvider.of<TransactionListCubit>(context)
                .fillWithMockTransactions();
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
