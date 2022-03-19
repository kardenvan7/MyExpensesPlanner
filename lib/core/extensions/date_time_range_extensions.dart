import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses_planner/core/extensions/date_time_extensions.dart';
import 'package:my_expenses_planner/core/extensions/string_extensions.dart';

extension DateTimeRangeFactory on DateTimeRange {
  static DateTimeRange lastMonth() {
    final _now = DateTime.now();
    final _beginningOfCurrentMonth = DateTime(_now.year, _now.month);

    return DateTimeRange(start: _beginningOfCurrentMonth, end: _now);
  }

  bool get isWithinOneYear => start.isSameYearWith(end);
  bool get isWithinOneMonth => start.isSameMonthAndYearWith(end);
  bool get isWithinOneDay => start.isSameDayWith(end);

  bool get startsInBeginningOfMonth => start.day == 1;

  String toFormattedString(BuildContext context) {
    if (start.isSameDayWith(end)) {
      return DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(start);
    } else if (startsInBeginningOfMonth &&
        isWithinOneMonth &&
        (end.isToday || end.isLastDayOfMonth)) {
      return DateFormat.yMMMM(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(start).toStandardCase();
    } else {
      return '${DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(start)} - ${DateFormat.yMMMMd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(end)}';
    }
  }
}
