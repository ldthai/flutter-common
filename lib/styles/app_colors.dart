import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static int hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  static Color colorFromString(String color) {
    return color != null && color.length > 0
        ? Color(hexStringToHexInt(color))
        : Colors.transparent;
  }

  static const Color primary = const Color.fromRGBO(255, 220, 0, 1);
  static const Color bg = const Color.fromRGBO(236, 236, 236, 1);
  static const Color primaryHint = const Color.fromRGBO(233, 233, 233, 1);
  static const Color tabNormal = const Color.fromRGBO(161, 161, 161, 1);
  static const Color tabActived = const Color.fromRGBO(255, 36, 32, 1);
  static const Color textHint = const Color.fromRGBO(161, 161, 161, 1);
  static const Color mediumGreen = const Color(0xff39b54a);
  static const Color overlay = const Color.fromRGBO(0, 0, 0, 0.4);
  static const Color line = const Color.fromRGBO(233, 233, 233, 1);
  static const Color buttonHint = const Color(0xfff3f3f3);
  static const Color buttonHintBorder = const Color(0xffe2e2e2);
  static const Color inputBg = const Color(0xfff7f7f7);
  static const Color inputBorder = const Color(0xffe2e2e2);
}
