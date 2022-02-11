class ValueWrapper<T> {
  ValueWrapper({required this.value});

  final T? value;

  bool get hasValue => value != null;
}
