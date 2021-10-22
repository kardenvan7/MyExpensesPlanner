import 'package:flutter/material.dart';

extension HexColor on Color {
  String toHexString() {
    return value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();

    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('FF');
    }

    if (hexString.length < 6 || hexString.length > 9) {
      throw const FormatException('Incorrect string format provided');
    }

    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
