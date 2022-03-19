import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';

class PeriodStatisticsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PeriodStatisticsAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListCubit, TransactionListState>(
      builder: (context, state) {
        return AppBar(
          title: AutoSizeText(
            _getTitle(context: context, dateTimeRange: state.dateTimeRange!),
            minFontSize: 12,
            maxLines: 1,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                final _now = DateTime.now();

                showDateRangePicker(
                  context: context,
                  firstDate: DateTime(_now.year - 1),
                  lastDate: _now,
                  initialDateRange: state.dateTimeRange,
                ).then(
                  (DateTimeRange? value) {
                    if (value != null) {
                      BlocProvider.of<TransactionListCubit>(context)
                          .onDateTimeRangeChange(value);
                    }
                  },
                );
              },
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        );
      },
    );
  }

  String _getTitle({
    required DateTimeRange dateTimeRange,
    required BuildContext context,
  }) {
    return dateTimeRange.toFormattedString(context);
  }
}
