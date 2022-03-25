import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/extensions/date_time_range_extensions.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/transaction_list/transaction_list_cubit.dart';

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
        IconButton(
          onPressed: () {
            final _now = DateTime.now();

            showDateRangePicker(
                useRootNavigator: false,
                context: context,
                firstDate: DateTime(_now.year - 1),
                lastDate: _now,
                initialDateRange: dateTimeRange,
                builder: (context, child) {
                  final _contextTheme = Theme.of(context);
                  final _appSettings =
                      BlocProvider.of<AppSettingsCubit>(context).state;
                  return Theme(
                    data: _contextTheme.copyWith(
                      dialogTheme: _contextTheme.dialogTheme.copyWith(),
                      colorScheme: _contextTheme.colorScheme.copyWith(
                        onBackground: Colors.grey,
                        primary: _appSettings.isDarkTheme
                            ? Colors.white54
                            : Colors.black26,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(30, 20),
                          maximumSize: const Size(110, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          backgroundColor: _appSettings.isDarkTheme
                              ? Colors.black54
                              : Colors.black54,
                          textStyle: TextStyle(
                            height: 1.3,
                            color: _appSettings.isDarkTheme
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    child: AlertDialog(
                      buttonPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.zero,
                      content: SizedBox(
                        height: 500,
                        child: child!,
                      ),
                    ),
                  );
                }).then(
              (DateTimeRange? value) {
                if (value != null) {
                  final _range = DateTimeRange(
                    start: value.start.startOfDay,
                    end: value.end.endOfDay,
                  );

                  BlocProvider.of<TransactionListCubit>(context)
                      .onDateTimeRangeChange(_range);
                }
              },
            );
          },
          icon: const Icon(Icons.calendar_today),
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
