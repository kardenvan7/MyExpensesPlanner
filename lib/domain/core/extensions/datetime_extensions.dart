extension DateTimeExt on DateTime {
  operator >(DateTime otherDate) {
    return millisecondsSinceEpoch > otherDate.millisecondsSinceEpoch;
  }
}
