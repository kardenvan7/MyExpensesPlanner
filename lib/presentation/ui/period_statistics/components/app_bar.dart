import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_planner/core/extensions/datetime_extensions.dart';

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
      title: Text(_getTitle(context)),
      centerTitle: true,
    );
  }

  String _getTitle(BuildContext context) {
    if (dateTimeRange.start.isSameDayWith(dateTimeRange.end)) {
      return DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(dateTimeRange.start);
    } else {
      return '${DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(dateTimeRange.start)} - ${DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(dateTimeRange.end)}';
    }
  }
}
