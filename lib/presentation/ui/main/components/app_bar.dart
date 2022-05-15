import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/constants.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/date_range_picker.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: AutoSizeText(
        AppLocalizationsFacade.of(context).main_app_bar_title,
        maxLines: 1,
      ),
      actions: [
        if (ConfigConstants.isTest)
          IconButton(
            onPressed: () {
              DI.instance<ITransactionsCase>().deleteAll();
            },
            icon: const Icon(Icons.delete),
          ),
        if (ConfigConstants.isTest)
          IconButton(
            onPressed: () {
              DI.instance<ITransactionsCase>().fillWithMockTransactions();
            },
            icon: const Icon(Icons.add),
          ),
        BlocBuilder<TransactionListCubit, TransactionListState>(
          builder: (context, state) {
            return CustomDateRangePickerIcon(
              initialDateTimeRange: state.dateTimeRange,
              onDateTimeRangePicked: (DateTimeRange? dateTimeRange) {
                if (dateTimeRange != null) {
                  final _dateTimeRange = DateTimeRange(
                    start: dateTimeRange.start.startOfDay,
                    end: dateTimeRange.end.endOfDay,
                  );

                  BlocProvider.of<TransactionListCubit>(context)
                      .onDateTimeRangeChange(_dateTimeRange);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
