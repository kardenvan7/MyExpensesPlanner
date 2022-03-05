extension StringExt on String {
  String toStandardCase() {
    final String _string = this;
    final StringBuffer _buffer = StringBuffer(_string[0].toUpperCase());

    final String _rest = _string.substring(1);
    _buffer.write(_rest.toLowerCase());

    return _buffer.toString();
  }

  bool get isOneWord {
    return wordCount == 1;
  }

  int get wordCount {
    return trim().split(' ').length;
  }
}
