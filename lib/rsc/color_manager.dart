import 'package:flutter/material.dart';

class AppColors {
  static Color primary = HexColor.fromHex('#4A3AFF');
  static Color neutral = HexColor.fromHex('#6F6C90');
  static Color primary2 = HexColor.fromHex('#4CBFFF');
  static Color linear = HexColor.fromHex('#B5E0FF');
}

extension HexColor on Color {
  static Color fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = "FF" + hex; // 8 char with opacity 100%
    }
    return Color(int.parse(hex, radix: 16));
  }
}
