extension DoubleExtension on double {
  String toAmountString() {
    return toStringAsFixed(
      this < 99
          ? 2
          : this < 999
              ? 1
              : 0,
    );
  }
}
