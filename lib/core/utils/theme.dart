import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColor {
  static const Color white = Color(0xFFFFFFFF);
  static const Color fontBlack = Color(0xDE000000);
  static const Color logoBlue = Color(0xFF245f97);
  static const Color textFieldBackground = Color(0x1E000000);
  static const Color hintColor = Color(0x99000000);
  static const Color statusBarColor = Color(0x1e000000);
}

class CustomTheme {
  static ThemeData mainTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: CustomColor.logoBlue,
      accentColor: CustomColor.logoBlue,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(backgroundColor: CustomColor.logoBlue));
}
