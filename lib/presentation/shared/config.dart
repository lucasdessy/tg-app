// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';

class SharedConfigs {
  static _AppTheme get colors => _TGTheme();
  static String version = '';
  static EdgeInsets padding =
      const EdgeInsets.symmetric(vertical: 12, horizontal: 12);
  static Color whitenColor(Color color) {
    return Color.lerp(
      color,
      colors.brightness == Brightness.dark ? Colors.white : Colors.black,
      colors.lerpAmount,
    )!;
  }

  static String noUserImage() => colors.brightness == Brightness.light
      ? 'assets/user.png'
      : 'assets/user-dark.png';
}

abstract class _AppTheme {
  Color get primary;
  Color get secondary;
  Color get tertiary;
  double get lerpAmount;
  Brightness get brightness;

  Color get neutral =>
      brightness == Brightness.dark ? Colors.white : Colors.black;
}

class _TGTheme extends _AppTheme {
  @override
  final Color primary = const Color(0xffffffff);
  @override
  final Color secondary = const Color(0xff34d180);
  @override
  final Color tertiary = const Color(0xffc3c3c3);
  @override
  final double lerpAmount = 0.5;
  @override
  final Brightness brightness = Brightness.light;
}
