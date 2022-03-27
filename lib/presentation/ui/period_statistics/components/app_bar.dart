import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/date_range_picker.dart';

class PeriodStatisticsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PeriodStatisticsAppBar({
    required this.dateTimeRange,
    Key? key,
  }) : super(key: key);

  final DateTimeRange dateTimeRange;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AutoSizeText(
        _getTitle(context: context, dateTimeRange: dateTimeRange),
        minFontSize: 12,
        maxLines: 1,
      ),
      centerTitle: true,
      actions: [
        CustomDateRangePickerIcon(
          initialDateTimeRange: dateTimeRange,
          onDateTimeRangePicked: BlocProvider.of<TransactionListCubit>(context)
              .onDateTimeRangeChange,
        ),
      ],
    );
  }

  String _getTitle({
    required DateTimeRange dateTimeRange,
    required BuildContext context,
  }) {
    return dateTimeRange.toFormattedString(context);
  }
}
