import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  operator >(DateTime otherDate) {
    return microsecondsSinceEpoch > otherDate.microsecondsSinceEpoch;
  }

  operator >=(DateTime otherDate) {
    return microsecondsSinceEpoch >= otherDate.microsecondsSinceEpoch;
  }

  operator <(DateTime otherDate) {
    return microsecondsSinceEpoch < otherDate.microsecondsSinceEpoch;
  }

  operator <=(DateTime otherDate) {
    return microsecondsSinceEpoch <= otherDate.microsecondsSinceEpoch;
  }

  bool get isToday {
    final _now = DateTime.now();

    return year == _now.year && month == _now.month && day == _now.day;
  }

  bool get isYesterday {
    final _now = DateTime.now();

    return year == _now.year && month == _now.month && day == _now.day - 1;
  }

  bool get isLastDayOfMonth {
    final _nextDay = add(const Duration(days: 1));

    return !isSameMonthWith(_nextDay);
  }

  bool isSameYearWith(DateTime otherDate) {
    return year == otherDate.year;
  }

  bool isSameMonthWith(DateTime otherDate) {
    return month == otherDate.month;
  }

  bool isSameMonthAndYearWith(DateTime otherDate) {
    return isSameYearWith(otherDate) && month == otherDate.month;
  }

  bool isSameDayWith(DateTime otherDate) {
    return isSameMonthAndYearWith(otherDate) && day == otherDate.day;
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }

  bool isWithinRange(DateTimeRange range) {
    return millisecondsSinceEpoch >= range.start.millisecondsSinceEpoch &&
        millisecondsSinceEpoch <= range.end.millisecondsSinceEpoch;
  }
}
