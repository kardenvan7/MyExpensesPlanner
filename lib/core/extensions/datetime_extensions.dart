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

  bool isSameDayWith(DateTime otherDate) {
    return year == otherDate.year &&
        month == otherDate.month &&
        day == otherDate.day;
  }

  DateTime get withoutTime {
    return DateTime(year, month, day);
  }
}
