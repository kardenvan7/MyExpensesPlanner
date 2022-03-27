import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/customized_flutter_date_picker.dart';

class CustomDateRangePickerIcon extends StatelessWidget {
  const CustomDateRangePickerIcon({
    required this.onDateTimeRangePicked,
    this.initialDateTimeRange,
    Key? key,
  }) : super(key: key);

  final DateTimeRange? initialDateTimeRange;
  final void Function(DateTimeRange? dateTimeRange) onDateTimeRangePicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showCustomDateRangePicker(
          context: context,
          initialDateTimeRange: initialDateTimeRange,
        ).then(onDateTimeRangePicked);
      },
      icon: const Icon(Icons.calendar_today),
    );
  }
}

Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialDateTimeRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final DateTime _now = DateTime.now();

  return showCustomizedDateRangePicker(
    useRootNavigator: false,
    context: context,
    firstDate: firstDate ?? DateTime(_now.year - 1),
    lastDate: lastDate ?? _now,
    initialDateRange: initialDateTimeRange,
    builder: (context, child) {
      final _contextTheme = Theme.of(context);
      final _appSettings = BlocProvider.of<AppSettingsCubit>(context).state;

      return Theme(
        data: _contextTheme.copyWith(
          dialogTheme: _contextTheme.dialogTheme.copyWith(),
          colorScheme: _contextTheme.colorScheme.copyWith(
            onBackground: Colors.grey,
            primary: _appSettings.isDarkTheme ? Colors.white54 : Colors.black26,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              minimumSize: const Size(30, 20),
              maximumSize: const Size(110, 40),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              backgroundColor:
                  _appSettings.isDarkTheme ? Colors.black54 : Colors.black54,
              textStyle: TextStyle(
                height: 1.3,
                color:
                    _appSettings.isDarkTheme ? Colors.black87 : Colors.white70,
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
    },
  );
}
