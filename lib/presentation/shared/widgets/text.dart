import 'package:flutter/material.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

class AppText extends StatelessWidget {
  final String text;
  final bool bold;
  final TextAlign textAlign;
  final Color? color;
  const AppText(
      {required this.text,
      this.bold = false,
      this.textAlign = TextAlign.center,
      this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 16,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
        color: color ?? (SharedConfigs.colors.neutral),
      ),
    );
  }
}
